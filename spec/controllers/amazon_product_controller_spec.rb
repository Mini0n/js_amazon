require 'rails_helper'

RSpec.describe AmazonProductController, type: :controller do

  def populate_db
    service = AmazonProducts::AmazonProductsService.new
    service.fetch_product('B002QYW8LW')
    service.fetch_product('B0797G8P66')
    service.fetch_product('B002STPS1C')
  end

  describe '#index', :vcr, record: :none do
    it 'shows all stored products' do
      populate_db
      get 'index'
      result = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.status).to eq result['status']
      expect(result['products'].length).to eq 3
    end
  end


  describe '#show', :vcr, record: :none do
    context 'stored product' do
      it 'shows stored product' do
        populate_db
        get 'show', params: { asin: 'B002QYW8LW' }
        result = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(response.status).to eq result['status']
        expect(result['products'].length).to eq 1
        expect(result['products'].first['rank']).to eq '4.7/5'
      end
    end

    context 'new product' do
      it 'get & shows new product' do
        get 'show', params: { asin: 'B002QYW8LW' }
        result = JSON.parse(response.body)

        expect(AmazonProduct.count).to eq 1
        expect(response.status).to eq 200
        expect(response.status).to eq result['status']
        expect(result['products'].length).to eq 1
        expect(result['products'].first['rank']).to eq '4.7/5'
      end
    end

    context 'invalid product' do
      it 'can not find the product' do
        get 'show', params: { asin: 'B07G2PY8KH' }
        result = JSON.parse(response.body)

        expect(AmazonProduct.count).to eq 0
        expect(result['products'].length).to eq 0
        expect(result['error'].present?).to be true
      end
    end
  end
end
