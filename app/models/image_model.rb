require 'validate_url'

class ImageModel < ApplicationRecord

  include ActiveModel::Validations::HelperMethods

  attr_accessor :url, :width, :height

  validates_presence_of :url, :width, :height
  validates_numericality_of :width, :height, only_integer: true, greater_than: 0
  validates_numericality_of :width, only_integer: true, greater_than: 0
  validates :url, url: true, format: {with: /\.(png|jpg|gif|jpeg)\Z/i}

  def persisted?
     false
   end

end
