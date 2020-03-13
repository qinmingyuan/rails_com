# frozen_string_literal: true
module RailsCom::AssetsHelper

  # Assets path: app/assets/javascripts/controllers
  def origin_js_load(**options)
    exts = ['.js'] + Array(options.delete(:ext))
    asset_path, ext = assets_load_path(exts: exts, suffix: options.delete(:suffix))

    [javascript_include_tag(asset_path, options).html_safe, asset_path(asset_path + ext)]
  end

  def js_load(**options)
    r, _ = origin_js_load(options)
    r
  end

  def remote_js_load(**options)
    _, r = origin_js_load(options)
    r
  end

  def js_ready(**options)
    js_load(suffix: 'ready', **options)
  end

  # Assets path: app/assets/stylesheets/controllers
  def css_load(**options)
    exts = ['.css'] + Array(options.delete(:ext))
    asset_path, _ = assets_load_path(exts: exts, suffix: options.delete(:suffix))

    stylesheet_pack_tag(asset_path, options).html_safe
  end

  private
  def assets_load_path(exts: [], suffix: nil)
    exts.uniq!
    filename = "controllers/#{controller_path}/#{@_rendered_template}"
    filename = [filename, '-', suffix].join if suffix

    exts.each do |ext|
      if Webpacker.manifest.lookup(filename + ext)
        return [filename, ext]
      end
    end

    []
  end

end
