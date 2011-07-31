require 'RMagick'

def achievement(first_line, second_line)
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
