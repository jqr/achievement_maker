require_relative "./gravatar"
require "rmagick"

# TODO: better names
BACKGROUND    = "#3B3F40"
CIRCLE        = "#1B1D1A"
CIRLCE_OFF    = "#5D5F5E"
CIRCLE_CENTER = "#1B1D1A"
GREEN         = "#6BBC6F"

TRANSPARENT   = "rgba(0,0,0,255)"
FULL_OPACITY  = "rgba(255,255,255,255)"

def draw_circle(draw, x, y, radius)
  draw.circle(x, y, x, y + radius)
end

def draw_rounded_area(draw, width, height)
  radius = height / 2
  draw_circle(draw, radius, radius, radius)
  draw_circle(draw, width - radius - 1, radius, radius)
  draw.rectangle(radius, 0, width - radius - 1, height)
end

def achievement(first_line, second_line, email: nil)
  width = 423
  height = 67

  draw = Magick::Draw.new

  draw.fill(BACKGROUND)
  draw_rounded_area(draw, width, height)

  radius = height / 2
  dark_circle_radius = radius - 4

  draw.fill(CIRCLE)
  draw_circle(draw, radius, radius, dark_circle_radius)

  player_circle_outer_radius = dark_circle_radius - 2
  draw.fill(CIRLCE_OFF)
  draw_circle(draw, radius, radius, player_circle_outer_radius)

  #

  odraw = Magick::Draw.new
  mdraw = Magick::Draw.new
  overlay = Magick::Image.new(width, height)
  mask = Magick::Image.new(width, height)

  odraw.fill(GREEN)
  odraw.rectangle(0, 0, width, height)
  odraw.draw(overlay)

  # mdraw.fill(TRANSPARENT)
  mdraw.rectangle(0, 0, width, height)
  mdraw.fill(FULL_OPACITY)

  player_circle_highlight_outer_radius = player_circle_outer_radius - 1
  draw_circle(mdraw, radius, radius, player_circle_highlight_outer_radius)

  mdraw.fill(TRANSPARENT)
  mdraw.rectangle(radius, 0, width, height)
  mdraw.rectangle(0, radius, radius, height)

  mdraw.draw(mask)

  mask.alpha(Magick::OffAlphaChannel)
  # mask.matte = false
  # overlay.matte = true
  overlay.alpha(Magick::OnAlphaChannel)

  overlay.composite!(mask, 0, 0, Magick::CopyAlphaCompositeOp)
  draw.composite(0, 0, width, height, overlay)

  # Crosshair
  draw.fill(CIRCLE_CENTER)
  crosshair_width = 6
  draw.rectangle(radius - crosshair_width / 2, radius - player_circle_highlight_outer_radius - 1, radius + crosshair_width / 2, radius * 2 - crosshair_width)
  draw.rectangle(radius - player_circle_highlight_outer_radius - 1, radius - crosshair_width / 2, radius * 2 - crosshair_width, radius + crosshair_width / 2)
  player_circle_highlight_inner_radius = player_circle_outer_radius - 7
  draw_circle(draw, radius, radius, player_circle_highlight_inner_radius)

  if email && (avatar = Gravatar.new(email).image_data)
    odraw = Magick::Draw.new
    mdraw = Magick::Draw.new
    aimg = Magick::Image.from_blob(avatar).first
    overlay = Magick::Image.new(width, height)
    mask = Magick::Image.new(width, height)

    odraw.composite(radius - player_circle_highlight_outer_radius - 1, radius - player_circle_highlight_outer_radius - 1, 54, 54, aimg)
    odraw.draw(overlay)
    mdraw.fill(TRANSPARENT)
    mdraw.rectangle(0, 0, width, height)
    mdraw.fill(FULL_OPACITY)
    draw_circle(mdraw, radius, radius, 16)
    mdraw.draw(mask)
    mask.alpha(Magick::OffAlphaChannel)
    # mask.matte = false
    # overlay.matte = true
    overlay.alpha(Magick::OnAlphaChannel)

    overlay.composite!(mask, 0, 0, Magick::CopyAlphaCompositeOp)
    draw.composite(0, 0, width, height, overlay)
  end

  draw.fill("#FFFFFF")

  draw.font("fonts/LiberationSans-Regular.ttf")
  draw.font_size("15.5")
  draw.kerning("0.65")
  draw.text(75, 29, first_line)

  draw.font_size("15.5")
  draw.kerning("0.4")
  draw.text(75, 50, second_line)

  canvas = Magick::Image.new(width, height) { |c| c.background_color = "none"; c.format = "png" }
  draw.draw(canvas)
  canvas
end
