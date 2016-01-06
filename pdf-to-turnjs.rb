require 'rubygems'
require 'bundler/setup'

require 'rmagick'

def write_images(img, n)
  large = 1443
  medium = 650
  small = 100
  img.resize_to_fit!(large, large)
  img.write("#{n}-large.jpg")
  img.resize_to_fit!(medium, medium)
  img.write("#{n}.jpg")
  img.resize_to_fit!(small, small)
  img.write("#{n}-thumb.jpg")
end

n = 0
pdf_file_name = "1.pdf"

Magick::ImageList.new(pdf_file_name) do
  self.density = 200
  self.quality = 90
  self.colorspace = Magick::SRGBColorspace
end.each_with_index do |img, i|
  img.alpha Magick::DeactivateAlphaChannel
  n += 1
  puts n
  puts img.columns
  puts img.rows
  if img.rows > img.columns
    puts "Vertical!"
    write_images(img, n)
  else
    cropped_left = img.crop(0, 0, img.columns/2, img.rows)
    write_images(cropped_left, n)
    n += 1
    cropped_right = img.crop(img.columns/2, 0, img.columns/2, img.rows)
    write_images(cropped_right, n)
  end
end