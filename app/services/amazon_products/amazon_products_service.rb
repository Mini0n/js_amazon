module AmazonProducts
  class AmazonProductsService

    def initialize
      @products_url = 'https://www.amazon.com/dp/'
      @conn = Faraday.new(url: @products_url)
    end


    def fetch_product(ansi)
      res = @conn.get ansi
      doc = Nokogiri::HTML(res.body)

      byebug
    end



    # Checks if a product has been stored by its ANSI
    # @param: [string] ansi
    #
    # @returns [AmazonProduct || nil]
    def product_stored?(ansi)
      AmazonProduct.where(ansi: ansi).first
    end



  end
end