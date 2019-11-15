require 'rails_helper'

RSpec.describe AmazonProductController, type: :controller do

  describe '#index' do
    it 'shows all stored products' do
      get 'index'
      result = JSON.parse(response.body)

      puts result.to_s
    end
  end


  describe '#show' do
    context 'stored product' do
      it 'shows stored product' do
        get 'show', params: { asin: 'B002QYW8LW' }
        result = JSON.parse(response.body)

        puts result.to_s
      end
    end

    context 'new product' do
      it 'get & shows new product' do
        get 'show', params: { asin: 'B002QYW8LW' }
        result = JSON.parse(response.body)

        puts result.to_s
      end
    end
  end
end
