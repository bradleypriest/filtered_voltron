#!/usr/bin/env ruby

require 'http'

# Very naive implementation, aiming for minimal false negatives for now
# Currently:
#   - If it has a tags section
#   - If the tag is in any part of the text
def tagged_with?(text, tag)
  !text.include?("tags:") || text.include?(tag)
end

def filter_wishlist(input_url, output_path, tag='pve')
  wishlist_text = HTTP.get(input_url).body.to_s

  filtered_wishlist = wishlist_text.split(/\n\n\/\//).select do |chunk|
    !chunk.include?("dimwishlist") || tagged_with?(chunk.downcase, tag)
  end.join("\n\n//")

  File.write("dist/#{output_path}", filtered_wishlist)
end

filter_wishlist('https://raw.githubusercontent.com/48klocs/dim-wish-list-sources/master/voltron.txt', 'voltron-pve.txt', 'pve')
filter_wishlist('https://raw.githubusercontent.com/48klocs/dim-wish-list-sources/master/choosy_voltron.txt', 'choosy_voltron-pve.txt', 'pve')
