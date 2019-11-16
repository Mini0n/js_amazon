class AmazonProduct < ApplicationRecord

  def get_all_json
    AmazonProduct.all.map{ |prod| prod.attributes }
  end

  def get_product(asin)
    result = service.fetch_product(asin)
    return { products: [result.attributes], error: '' } if result.present?

    { products: [], error: "Could not find product #{asin}" }
  end

  def service
    @service = AmazonProducts::AmazonProductsService.new if @service.nil?
  end
end
