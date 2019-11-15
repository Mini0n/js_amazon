require 'rails_helper'
require 'vcr'

RSpec.describe AmazonProducts::AmazonProductsService do


  before(:all) do
    @service = AmazonProducts::AmazonProductsService.new
  end

  describe '#fetch_product', :vcr, record: :new_episodes do
    context 'fetch an amazon product by its ASIN' do
      it 'succeeds' do
        result = @service.fetch_product('B002QYW8LW')

        expect(AmazonProduct.count).to eq 1
        expect(AmazonProduct.first.category).to eq 'Baby Products'
        expect(AmazonProduct.first.rank).to eq '4.7/5'
      end

      it 'succeeds (product already exists)' do
        # Create Product
        @service.fetch_product('B0797G8P66')
        expect(AmazonProduct.count).to eq 1

        result = @service.fetch_product('B0797G8P66')

        expect(AmazonProduct.count).to eq 1
        expect(AmazonProduct.first.category).to eq 'Electronics'
        expect(AmazonProduct.first.dimensions).to eq '5.5 x 4 x 1.5 inches'
      end

      it 'fails (product does not exists)' do
        result = @service.fetch_product('B07G2PY8KH')

        expect(result).to be nil
        expect(AmazonProduct.count).to eq 0
      end
    end
  end

end
