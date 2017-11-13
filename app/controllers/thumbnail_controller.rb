require 'securerandom'

class ThumbnailController < ApplicationController

  UPLOAD_URL = "#{Rails.root}/public/uploads/"
  FORMAT = 'jpeg'
  # image padding
  GRAVITY = 'center'
  BACKGROUND = 'black'
  MULTI = 'x'
  RESIZE_CONFIG = '>'
  DOT = '.'
  IMAGE_FOLDER = '/uploads/'

  Rails.logger = Logger.new("#{Rails.root}/log/thumbnail.log")

  def thumbnail_create

    result = validate_query_param_existences
    #if contain errors, validation failed
    if !result.empty?
      payload = get_payload("Requested parameters are missing. #{result}", 400)
      render :json => payload, :status => :bad_request
      return
    end

    @image_model = ImageModel.new
    @image_model.url = params[:url]
    @image_model.width = params[:width]
    @image_model.height = params[:height]

    if !@image_model.valid?
      payload = get_payload("Failed to validate sent parameters. #{@image_model.errors.messages}", 400)
      render :json => payload, :status => :bad_request
      return
    end

    #fetching the given image
    get_image_from_uri
    if @image.is_a? String
      payload = get_payload(@image, 400)
      render :json => payload, :status => :bad_request
      return
    end

    #verify the given proportion against the original proportion
    if !image_size_allowed
      payload = get_payload('New dimensions are bigger then the original image, this is not supported.', 501)
      render :json => payload, :status => :not_supported
      return
    end

    begin
      #resize the image while maintaining its aspect ratio, left area will be padded in black while the image is centered
      @image.combine_options do |i|
        i.resize @image_model.width + MULTI + @image_model.height + RESIZE_CONFIG
        i.gravity GRAVITY
        i.background BACKGROUND
        i.extent @image_model.width + MULTI + @image_model.height
      end

      #the image will be saved in a unified format
      if (@image.type != FORMAT)
        @image.format FORMAT
      end

      image_url, file_name = generate_path_to_persist

      #saving the manipulated image
      @image.write image_url

      #serving the manipulated image to the client
      redirect_to IMAGE_FOLDER + file_name

    rescue Exception => msg
      Rails.logger.error("Failed to manipulate image." + msg.to_s)
      payload = get_payload('Failed to handle request', 422)
      render :json => payload, :status => :unprocessable_entity
    end

  end

  #prepare the payload for the json object
  def get_payload(msg, code)
    payload = {
        error: msg,
        status: code
    }
  end

  #generate a unique path for the image
  def generate_path_to_persist
    file_name = SecureRandom.hex
    full_file_name = file_name + DOT + FORMAT
    return UPLOAD_URL + full_file_name, full_file_name
  end

  #validating that all expected query param were sent, this does not validate the content
  def validate_query_param_existences
    query_params = ["url", "width", "height"]

    missing_params=[]
    message = ""
    query_params.each do |param|
      begin
        params.require(param)
      rescue ActionController::ParameterMissing
        missing_params.push param
      end
    end

    if missing_params.size > 0
      message = "Missing params #{missing_params}"
    end
    return message
  end

  #Fetch the image from the given uri into minimagick object
  def get_image_from_uri
    begin
      @image = MiniMagick::Image.open(@image_model.url)
    rescue Exception => general_msg
      Rails.logger.error('Failed to open image url.' + general_msg.to_s)
      @image = 'General error has occurred in opening the image file.'
    end

    #check if the given proportion are not greater then the original image proportion
    def image_size_allowed
      return @image.width > @image_model.width.to_i && @image.height > @image_model.height.to_i
    end

  end

end


