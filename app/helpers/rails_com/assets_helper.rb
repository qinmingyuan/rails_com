# frozen_string_literal: true

module RailsCom::AssetsHelper
  # Assets path: app/assets/javascripts/controllers
  def origin_js_load(**options)
    exts = ['.js'] + Array(options.delete(:ext))
    path, ext = assets_load_path(exts: exts, suffix: options.delete(:suffix))

    if path
      [javascript_pack_tag(path, **options).html_safe, asset_pack_path(path + ext)]
    else
      []
    end
  end

  def js_load(**options)
    r, _ = origin_js_load(**options)
    r
  end

  def remote_js_load(**options)
    _, r = origin_js_load(**options)
    r
  end

  # Assets path: app/assets/stylesheets/controllers
  def css_load(**options)
    exts = ['.css'] + Array(options.delete(:ext))
    path, _ = assets_load_path(exts: exts, suffix: options.delete(:suffix))
    return unless path

    stylesheet_pack_tag(path, **options).html_safe
  end

  private

  def assets_load_path(exts: [], suffix: nil)
    exts.uniq!
    filename = "controllers/#{controller_path}/#{@_rendered_template}"
    filename = [filename, '-', suffix].join if suffix

    exts.each do |ext|
      return [filename, ext] if Webpacker.manifest.lookup(filename + ext)
    end

    []
  end
end
