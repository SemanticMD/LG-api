require 'rails_helper'

RSpec.describe Lion, :type => :model do
  describe 'validations' do
    subject { Fabricate :lion }
    it { should be_valid }

    describe 'not valid is primary image set not in image sets' do
      subject { Fabricate.build(:lion, primary_image_set: Fabricate(:image_set)) }
      it { should_not be_valid }
    end
  end

  describe 'create from image set' do
    let(:image_set) { Fabricate :image_set }
    let(:name) { 'isaac' }
    let!(:lion) { Lion.create_from_image_set(image_set, name) }

    it { expect(lion).to be_valid }
    it { expect(lion.name).to eq name }
    it { expect(lion.organization).to eq image_set.organization }
    it { expect(image_set.reload.lion).to eq lion }
  end

  describe 'search' do
    subject { Lion.search(params) }

    context 'by name' do
      let!(:lion1) { Fabricate :lion }
      let!(:lion2) { Fabricate :lion }
      let(:name) { lion1.name }

      let(:params) { {name: name} }

      it { expect(subject).to eq([lion1]) }
    end

    context 'by gender' do
      let!(:male_lion) { Fabricate :lion }
      let!(:female_lion) { Fabricate :female_lion }

      let(:params) { {gender: 'female'} }

      it { expect(subject).to eq([female_lion]) }
    end

    context 'by tag' do
      let(:tag_1) { LG::ImageSetMetaData::OPTIONS[0] }
      let(:tag_2) { LG::ImageSetMetaData::OPTIONS[1] }

      let(:image_set_no_tags) { Fabricate(:image_set, tags:[]) }
      let(:image_set_tag_1) { Fabricate(:image_set, tags:[tag_1]) }
      let(:image_set_tag_1_and_2) { Fabricate(:image_set, tags:[tag_1, tag_2]) }

      let!(:lion_no_tags) {
        Fabricate(:lion,
                  image_sets:[image_set_no_tags],
                  primary_image_set:image_set_no_tags)
      }
      let!(:lion_1_tag) {
        Fabricate(:lion,
                  image_sets:[image_set_tag_1],
                  primary_image_set:image_set_tag_1)
      }
      let!(:lion_2_tags) {
        Fabricate(:lion,
                  image_sets:[image_set_tag_1_and_2],
                  primary_image_set:image_set_tag_1_and_2)
      }

      context 'no tags' do
        let(:params) { {tags: []} }
        it { expect(subject).to include(lion_no_tags) }
        it { expect(subject).to include(lion_1_tag) }
        it { expect(subject).to include(lion_2_tags) }
      end

      context '1 tag' do
        let(:params) { {tags: [tag_1]} }
        it { expect(subject).not_to include(lion_no_tags) }
        it { expect(subject).to include(lion_1_tag) }
        it { expect(subject).to include(lion_2_tags) }
      end

      context '2 tags includes image sets with BOTH tags' do
        let(:params) { {tags: [tag_1, tag_2]} }
        it { expect(subject).not_to include(lion_no_tags) }
        it { expect(subject).not_to include(lion_1_tag) }
        it { expect(subject).to include(lion_2_tags) }
      end
    end
  end
end
