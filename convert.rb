#!/usr/bin/env ruby

require 'http'

def filter_wishlist(input_url, output_path, tag='pve')
  wishlist_text = HTTP.get(input_url).body.to_s

  filtered_wishlist = wishlist_text.split(/\n\n\/\//).select do |chunk|
    downcased = chunk.downcase
    !downcased.include?("dimwishlist") ||
      !downcased.include?("tags:") ||
      downcased.include?(tag)
  end.join("\n\n//")

  File.write("dist/#{output_path}", filtered_wishlist)
end

filter_wishlist('https://raw.githubusercontent.com/48klocs/dim-wish-list-sources/master/voltron.txt', 'voltron-pve.txt', 'pve')
filter_wishlist('https://raw.githubusercontent.com/48klocs/dim-wish-list-sources/master/choosy_voltron.txt', 'choosy_voltron-pve.txt', 'pve')