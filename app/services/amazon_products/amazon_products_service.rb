module AmazonProducts
  class AmazonProductsService

    def initialize
      @products_url = 'https://www.amazon.com/dp/'
      @conn = Faraday.new(url: @products_url)
    end


    # Fetches an AmazonProduct for the given ASIN
    # if the product can't be fetched, it returns nil
    # if the product it's already stored, it returns it from the DB
    # if the product isn't stored, it is created and then returned
    # @param: [string] ASIN
    #
    # @result: [AmazonProduct]
    def fetch_product(asin)
      result = product_stored?(asin)
      return result if result.present?
      
      result = @conn.get asin
      return nil unless result.status == 200

      product = parse_product(result, asin)
      product = AmazonProduct.new(product)
      return product if product.save
      
      nil
    end

    # Parses a Product Faraday::Response and returns
    # an a hash with AmazonProduct data
    # @param: [Faraday::Response]
    #
    # @returns: [Hash <AmazonProduct>]
    def parse_product(conn_result, asin)
      doc = Nokogiri::HTML(conn_result.body)

      # Load details when response body is to long, Nokogiri won't load it all
      d_init = conn_result.body.index("<div id=\"prodDetails\"")
      # book case
      d_init = conn_result.body.index("<div id=\"detail-bullets\"") if d_init.nil?
      d_end = conn_result.body.length

      details_doc = Nokogiri::HTML(conn_result.body[d_init..d_end])
      details = product_details(details_doc)

      {
        asin: asin,
        name: get_name(doc),
        category: get_category(doc),
        rank: get_rank(details_doc),
        weight: get_weight(details),
        dimensions: get_dimensions(details)
      }
    end

    # Gets the product name from the Nokogiri document
    # @param: [Nokogiri::HTML::Document]
    #
    # @returns: [String]
    def get_name(doc)
      doc.css("#productTitle").inner_text.strip
    end

    # Gets the category information from the Nokogiri document
    # @param: [Nokogiri::HTML::Document]
    #
    # @returns: [String]
    def get_category(doc)
      doc.css('.a-unordered-list.a-horizontal.a-size-small > li').first
         .inner_text.strip
    end

    # Gets the rank information from the Nokogiri document
    # @param: [Hash] product_details result hash
    #
    # @returns: [String]
    def get_rank(details)
      details.css('.a-icon-alt').first.inner_text
         .delete('^0-9. ').strip.split(' ').join('/')
    end

    # Gets the weight information from the product details
    # @param: [Hash] product_details result hash
    #
    # @returns: [String]
    def get_weight(details)
      details.select{ |k,v| k.include?('Weight') }.first.last
    end

    # Gets the dimensions information from the product details
    # @param: [Hash] product_details result hash
    #
    # @returns: [String]
    def get_dimensions(details)
      details.select{ |k,v| k.include?('Dimension') }.first.last
    end

    # Extracts product details from the Products Information table
    # and returns it as a Hash
    # @param: [Nokogiri::HTML::Document]
    # 
    # @return [Hash<String:String>]
    def product_details(doc)
      details = doc.css('#prodDetails').css('tr > th, td')
      # book case
      return product_details_book(doc) if details.empty?

      res = {}
      details.each_slice(2) do |n, v| 
        res.merge!({n.inner_text.strip => v.inner_text.strip}) 
      end
      res
    end

    # Same as product_details but for books
    def product_details_book(doc)
      res = {}
      details = doc.css('#detail-bullets').css('li')
      details.each do |detail|
        key = detail.children[0].inner_text
        value = detail.children[1].inner_text
        value = value.gsub('(','') if key.include?('Weight')
        res.merge!({key.strip => value.strip})
      end
      res
    end

    def book_weight(weight_string)
      
    end

    # Checks if a product has been stored by its ANSI
    # @param: [string] ansi
    #
    # @returns [AmazonProduct || nil]
    def product_stored?(asin)
      AmazonProduct.where(asin: asin).first
    end

  end
end