require 'digest/md5'
require 'faraday'
require 'RMagick'

def gravatar_image(email, dims = 46)
  client = Faraday::Connection.new(:url => "http://www.gravatar.com/")
  hash = Digest::MD5.hexdigest(email.downcase.strip)
  client.get("/avatar/#{hash}?s=#{dims}&d=mm").body
end

def achievement(first_line, second_line, gravatar = nil)
  canvas = Magick::Image.new(423, 67) { |c| c.background_color = "none"; c.format = "png" }
  draw = Magick::Draw.new

  draw.fill("#3B3F40")
  draw.circle(33,33, 33,66)
  draw.circle(423 - 34,33, 423 - 34,66)
  draw.rectangle(33, 0, 423 - 34,67)
  
  draw.fill("#1B1D1A")
  draw.circle(33,33, 33,62)

  draw.fill("#5D5F5E")
  draw.circle(33,33, 33,60)

  draw.fill("#1B1D1A")
  
  draw.rectangle(30, 6, 36,60)
  draw.rectangle(6, 30, 60,36)
  draw.circle(33,33, 33,54)

  if gravatar && (avatar = gravatar_image(gravatar))
    odraw = Magick::Draw.new
    mdraw = Magick::Draw.new
    aimg = Magick::Image.from_blob(avatar).first
    overlay = Magick::Image.new(423, 67)
    mask = Magick::Image.new(423, 67)

    odraw.composite(6, 8, 54, 54, aimg)
    odraw.draw(overlay)
    mdraw.fill("rgba(0,0,0,255)")
    mdraw.rectangle(0, 0, 423,67)
    mdraw.fill("rgba(255,255,255,255)")
    mdraw.circle(33, 33, 33, 54)
    mdraw.draw(mask)
    mask.matte = false
    overlay.matte = true
    overlay.composite!(mask, 0, 0, Magick::CopyOpacityCompositeOp)
    draw.composite(0, 0, 423, 67, overlay)
  end

  draw.fill("#FFFFFF")

  draw.font('fonts/LiberationSans-Regular.ttf')
  draw.font_size('15.5')
  draw.kerning('0.65')
  draw.text(75,29, first_line)

  draw.font_size('15.5')
  draw.kerning('0.4')
  draw.text(75,50, second_line)

  draw.draw(canvas)
  canvas
end
