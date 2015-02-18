require 'rails_helper'

RSpec.describe ImageSet, :type => :model do
  subject { Fabricate :image_set }
  it { should be_valid }

  describe 'validations' do
    describe 'main image not in image set' do
      subject { Fabricate.build(:image_set, main_image: Fabricate(:image)) }
      it { should_not be_valid }
    end

    describe 'main image from image set' do
      subject { Fabricate :image_set_with_images }
      it { should be_valid }
    end

    describe 'main image from image set' do
      subject { Fabricate :image_set_with_images }
      it { should be_valid }
    end

    describe 'main image is public' do
      subject { Fabricate :image_set_with_images }
      before { subject.main_image.update(is_public: false) }
      it { should_not be_valid }
    end

    describe 'with lion' do
      let(:lion) { Fabricate :lion }
      subject { Fabricate(:image_set, lion: lion) }
      it { should be_valid }
      it { expect(subject.lion).to eq lion }
    end

    describe 'bad lion id' do
      subject { Fabricate.build(:image_set, lion_id: 'bad id') }
      it { should_not be_valid }
    end
  end

  describe 'fetching cv_results for image_set' do
    let(:cv_request) { Fabricate :cv_request }
    let(:image_set) { cv_request.image_set }
    let(:cv_result) { Fabricate :cv_result, cv_request: cv_request }

    it { expect(image_set.cv_results).to include cv_result }
  end

  describe 'images does not include deleted images' do
    let(:image_set) { Fabricate :image_set_with_images }
    let(:deleted_image) { image_set.images.last }
    before {
      deleted_image.update(is_deleted: true)
      deleted_image.save
    }

    it { expect(image_set.images.reload).to_not include deleted_image }
  end

  describe 'destroying hides all images' do
    let!(:image_set) { Fabricate :image_set_with_images }

    it {
      image_set.images.each { |image|
        expect(image).to receive(:hide)
      }

      image_set.destroy
    }
  end

  describe 'viewable_images' do
    let!(:image_set) { Fabricate :image_set_with_images }

    it {
      expect(image_set.images.count).to equal 5
      expect(image_set.images.is_public.count).to equal 1
    }

    it {
      expect(image_set.viewable_images(nil)).to eq image_set.images.is_public
    }

    it {
      expect(image_set.viewable_images(nil)).to eq image_set.images.is_public
    }

    context 'with user' do
      let(:user) { Fabricate :user }

      it {
        expect(image_set.viewable_images(user)).to eq image_set.images.is_public
      }
    end

    context 'with owner user' do
      let(:user) { image_set.uploading_user }

      it {
        expect(image_set.viewable_images(user)).to eq image_set.images
      }
    end

    context 'with owner user' do
      let(:user) { Fabricate(:user, organization: image_set.organization) }

      it {
        expect(image_set.viewable_images(user)).to eq image_set.images
      }
    end
  end
end
