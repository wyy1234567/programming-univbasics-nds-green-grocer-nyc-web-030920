def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  counter = 0 
  while counter < collection.length do 
    return collection[counter] if name === collection[i][:item]
    counter += 1
  end
  nil
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  ans = []
  counter = 0 
  
  while counter < cart.length do 
    item = cart[counter][:item]
    ifSeen = find_item_by_name_in_collection(item, ans) 
    if ifSeen
      ifSeen[:count] += 1 
    else 
      cart[counter][:count] = 1
      ans.push(cart[counter])
    end
    counter += 1
  end
  ans
      
end

def mk_coupon_hash(c)
  rounded_unit_price = (c[:cost].to_f * 1.0 / c[:num]).round(2)
  {
    :item => "#{c[:item]} W/COUPON",
    :price => rounded_unit_price,
    :count => c[:num]
  }
end

# A nice "First Order" method to use in apply_coupons

def apply_coupon_to_cart(matching_item, coupon, cart)
  matching_item[:count] -= coupon[:num]
  item_with_coupon = mk_coupon_hash(coupon)
  item_with_coupon[:clearance] = matching_item[:clearance]
  cart << item_with_coupon
end

def apply_coupons(cart, coupons)
  i = 0
  while i < coupons.count do
    coupon = coupons[i]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item], cart)
    item_is_in_basket = !!item_with_coupon
    count_is_big_enough_to_apply = item_is_in_basket && item_with_coupon[:count] >= coupon[:num]

    if item_is_in_basket and count_is_big_enough_to_apply
      apply_coupon_to_cart(item_with_coupon, coupon, cart)
    end
    i += 1
  end

  cart
end

def apply_clearance(cart)
  i = 0
  while i < cart.length do
    item = cart[i]
    if item[:clearance]
      discounted_price = ((1 - CLEARANCE_ITEM_DISCOUNT_RATE) * item[:price]).round(2)
        item[:price] = discounted_price
    end
    i += 1
  end

  cart
end

def checkout(cart, coupons)
  total = 0
  i = 0

  ccart = consolidate_cart(cart)
  apply_coupons(ccart, coupons)
  apply_clearance(ccart)

  while i < ccart.length do
    total += items_total_cost(ccart[i])
    i += 1
  end

  total >= 100 ? total * (1.0 - BIG_PURCHASE_DISCOUNT_RATE) : total
end

# Don't forget, you can make methods to make your life easy!

def items_total_cost(i)
  i[:count] * i[:price]
end