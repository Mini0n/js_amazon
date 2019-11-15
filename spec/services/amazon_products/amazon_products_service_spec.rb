require 'rails_helper'
require 'vcr'

RSpec.describe AmazonProducts::AmazonProductsService do


  before(:all) do
    @service = AmazonProducts::AmazonProductsService.new
  end

  describe '#fetch_product', :vcr, record: :all_episodes do
    context 'fetch an amazon product by its ASIN' do
      it 'succeeds' do
        @service.fetch_product('B002QYW8LW')
      end

      it 'fails (product does not exists)' do
      end
    end
  end

end