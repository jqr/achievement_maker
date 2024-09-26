require_relative "./gravatar"

class Achievement
  # TODO: better names
  BACKGROUND    = "#3B3F40"
  CIRCLE        = "#1B1D1A"
  CIRLCE_OFF    = "#5D5F5E"
  CIRCLE_CENTER = "#1B1D1A"
  GREEN         = "#6BBC6F"
  WHITE         = "#FFFFFF"
  TRANSPARENT   = "rgba(0,0,0,255)"
  FULL_OPACITY  = "rgba(255,255,255,255)"

  FONT                = "fonts/LiberationSans-Regular.ttf"
  FONT_SIZE           = "15.5"
  FIRST_LINE_KERNING  = "0.65"
  SECOND_LINE_KERNING = "0.4"

  attr_accessor :first_line, :second_line, :email

  def initialize(achievement:, header: "ACHIEVEMENT UNLOCKED", email: nil)
    @first_line = header
    @second_line = achievement
    @email = email
  end

  def draw_circle(draw, x, y, radius)
    draw.circle(x, y, x, y + radius)
  end

  def draw_rounded_area(draw, width, height)
    radius = height / 2
    draw_circle(draw, radius, radius, radius)
    draw_circle(draw, width - radius - 1, radius, radius)
    draw.rectangle(radius, 0, width - radius - 1, height)
  end

  def render(width:, height:, scale:)
    draw = Magick::Draw.new

    draw.fill(BACKGROUND)
    draw_rounded_area(draw, width, height)

    radius = height / 2
    dark_circle_radius = radius - 4 * scale

    draw.fill(CIRCLE)
    draw_circle(draw, radius, radius, dark_circle_radius)

    player_circle_outer_radius = dark_circle_radius - 2 * scale
    draw.fill(CIRLCE_OFF)
    draw_circle(draw, radius, radius, player_circle_outer_radius)

    odraw = Magick::Draw.new
    mdraw = Magick::Draw.new
    overlay = Magick::Image.new(width, height)
    mask = Magick::Image.new(width, height)

    odraw.fill(GREEN)
    odraw.rectangle(0, 0, width, height)
    odraw.draw(overlay)

    mdraw.rectangle(0, 0, width, height)
    mdraw.fill(FULL_OPACITY)

    player_circle_highlight_outer_radius = player_circle_outer_radius - 1
    draw_circle(mdraw, radius, radius, player_circle_highlight_outer_radius)

    mdraw.fill(TRANSPARENT)
    mdraw.rectangle(radius, 0, width, height)
    mdraw.rectangle(0, radius, radius, height)

    mdraw.draw(mask)
    mask.alpha(Magick::OffAlphaChannel)
    overlay.alpha(Magick::OnAlphaChannel)

    overlay.composite!(mask, 0, 0, Magick::CopyAlphaCompositeOp)
    draw.composite(0, 0, width, height, overlay)

    # Crosshair
    draw.fill(CIRCLE_CENTER)
    crosshair_width = 6 * scale
    draw.rectangle(radius - crosshair_width / 2, radius - player_circle_highlight_outer_radius - 1, radius + crosshair_width / 2, radius * 2 - crosshair_width)
    draw.rectangle(radius - player_circle_highlight_outer_radius - 1, radius - crosshair_width / 2, radius * 2 - crosshair_width, radius + crosshair_width / 2)
    player_circle_highlight_inner_radius = player_circle_outer_radius - 7 * scale
    draw_circle(draw, radius, radius, player_circle_highlight_inner_radius)

    if email.to_s.size > 1 && (avatar = Gravatar.new(email).image_data)
      odraw = Magick::Draw.new
      mdraw = Magick::Draw.new
      aimg = Magick::Image.from_blob(avatar).first
      overlay = Magick::Image.new(width, height)
      mask = Magick::Image.new(width, height)

      odraw.composite(radius - player_circle_highlight_outer_radius - 1, radius - player_circle_highlight_outer_radius - 1, 54*scale, 54*scale, aimg)
      odraw.draw(overlay)
      mdraw.fill(TRANSPARENT)
      mdraw.rectangle(0, 0, width, height)
      mdraw.fill(FULL_OPACITY)
      draw_circle(mdraw, radius, radius, 16 * scale)
      mdraw.draw(mask)
      mask.alpha(Magick::OffAlphaChannel)
      overlay.alpha(Magick::OnAlphaChannel)

      overlay.composite!(mask, 0, 0, Magick::CopyAlphaCompositeOp)
      draw.composite(0, 0, width, height, overlay)
    end

    draw.fill(WHITE)

    draw.font(FONT)
    draw.font_size(FONT_SIZE.to_f * scale)
    draw.kerning(FIRST_LINE_KERNING)
    draw.text(75 * scale, 29 * scale, first_line)

    draw.font_size(FONT_SIZE.to_f * scale)
    draw.kerning(SECOND_LINE_KERNING)
    draw.text(75 * scale, 50 * scale, second_line)

    draw
  end


  def to_blob(format: "png", scale: 1)
    width = 423 * scale
    height = 67 * scale

    canvas = Magick::Image.new(width, height) do |c|
      if format == "jpeg" || format == "jpg"
        c.background_color = "#FFFFFF"
      else
        c.background_color = "none"
      end
      c.format = format
      c.density = 72 * scale
    end

    render(width:, height:, scale:).draw(canvas)
    canvas.to_blob
  end
end
