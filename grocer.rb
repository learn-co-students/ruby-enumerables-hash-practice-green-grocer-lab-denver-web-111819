def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item|
  item_name = item.keys[0]
  
  if cart_hash.has_key?(item_name)
    cart_hash[item_name][:count] += 1
  else
    cart_hash[item_name] = {
      count: 1,
      price: item[item_name][:price],
      clearance: item[item_name][:clearance]
    }
  end
end
cart_hash
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart[item]
      if cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
      cart[item][:count] -= coupon[:num]
      elsif cart[item][:count] >= coupon[:num] && cart.has_key?("#{item} W/COUPON")
      cart["#{item} W/COUPON"][:count] += coupon[:num]
      cart[item][:count] -= coupon[:num]
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |product_name, stats|
  stats[:price] -= stats[:price] * 0.2 if stats[:clearance]
  end
  cart
end


def checkout(cart, coupons)
  hash = consolidate_cart(cart)
  applied_coupons = apply_coupons(hash, coupons)
  applied_clearance = apply_clearance(applied_coupons)
  total = applied_coupons.reduce(0) {|acc, (key, value)| acc += value[:price] * value[:count]}
  total > 100 ? total * 0.9 : total
end
