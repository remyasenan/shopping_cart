class CheckoutController < ApplicationController
  def addToCart
    @items = []
  end

  def discountedTotal
    amount_cutoff_to_get_discount = 60              				  # hard coded first 4 variable for the time being, 
    percentage_discount_given = 10 				  					  # this value can be passed dynamicly from an admin view 	
    promo_new_price = 8.50
    pr_code_of_product_on_promotion = "001"	

    product_codes_list = params[:itemslist]  	  					   # List of entered product codes
    product_codes_arr = product_codes_list.split(',') 
    @display = []								  					   # Array to pass to view for displaying the items	
    total_price = 0.0
    num_products = Hash[*product_codes_arr.collect {|pr| [pr,0]}.flatten]  # Converting the product code array to a hash to store the product code with number of times checkout
    checked_out_products = Product.where('product_code IN (?)', product_codes_arr).map(&:attributes)                   # Getting documents from the db
    @original_prize_of_promo_product = 0 

    product_codes_arr.each do |prod|								    # looping through the checkedout items array
    current_product = checked_out_products.select {|this_product| this_product["product_code"] == prod.to_i.abs}.first # matching items with records extracted from db
      if current_product
      	 @display << "#{current_product["product_code"]} : #{current_product["name"]} : #{current_product["price"]}"   # assigning values to the variable to display in view
      	 cur_pr_code = current_product["product_code"].to_s.rjust(3,'0') # product_code converting to string with prefixed 0s      										  					                                        
      	 total_price += current_product["price"]
      
      	 if num_products[cur_pr_code]									 # Adding the count to each product codes 
      	   num_products[cur_pr_code] = (num_products[cur_pr_code]+1)
      	 end

      	 if ((cur_pr_code == pr_code_of_product_on_promotion) && (@original_prize_of_promo_product == 0))    # To get the original price of the product with discount
      	   @original_prize_of_promo_product = current_product["price"]
      	 end
      end   
    end
    promotional_price_diff = @original_prize_of_promo_product - promo_new_price							      # finding the difference between original price and discounted price of product with multiple products discount
    @discounted_total = calculateDiscount(total_price,num_products, amount_cutoff_to_get_discount, percentage_discount_given, pr_code_of_product_on_promotion, promotional_price_diff)
  end

  def calculateDiscount(tot_pri, num_prod, amount_cutoff, percent_disc, pr_code_of_prom, promo_price_diff)
  	 if ((num_prod[pr_code_of_prom] >= 2) && (tot_pri > amount_cutoff))										  # Checking if both conditions applicable
  	   discounted_price = discount_on_multiple_number_of_products(num_prod,pr_code_of_prom,tot_pri,promo_price_diff)
  	   discounted_price = discount_on_total_price(discounted_price,amount_cutoff,percent_disc)
  	 elsif ((num_prod[pr_code_of_prom] >= 2) || (tot_pri > amount_cutoff))
  	   if(num_prod[pr_code_of_prom] >= 2) 
  	     discounted_price = discount_on_multiple_number_of_products(num_prod,pr_code_of_prom,tot_pri,promo_price_diff)
  	   elsif (tot_pri > amount_cutoff)
  	 	 discounted_price = discount_on_total_price(tot_pri,amount_cutoff,percent_disc)
  	   end
  	 else 	
  	  discounted_price = tot_pri	
  	 end
  end


  def discount_on_multiple_number_of_products(num_prod,pr_code_of_prom,tot_pri,promo_price_diff)
    num_of_promo_items = num_prod[pr_code_of_prom]
    disc_price = tot_pri - (num_of_promo_items * promo_price_diff)
  end	

  def discount_on_total_price(tot_pri,amount_cutoff,percent_disc)	
    disc_price = (tot_pri - percent_disc.percent_of(tot_pri)).round(2)	
  end
end