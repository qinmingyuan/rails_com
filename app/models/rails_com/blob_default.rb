# frozen_string_literal: true

module RailsCom::BlobDefault
  extend ActiveSupport::Concern

  included do
    attribute :record_class, :string, comment: 'AR 类名，如 User'
    attribute :name, :string, comment: '名称, attach 名称，如：avatar'
    attribute :private, :boolean, comment: '是否私有'

    has_one_attached :file

    after_commit :delete_private_cache, :delete_default_cache, on: %i[create destroy]
    after_update_commit :delete_private_cache, if: -> { saved_change_to_private? }
    after_update_commit :delete_default_cache
  end

  def delete_private_cache
    r = Rails.cache.delete('blob_default/private')
    logger.debug "Cache key blob_default/private delete: #{r}"
  end

  def delete_default_cache
    r = Rails.cache.delete('blob_default/default')
    logger.debug "Cache key blob_default/default delete: #{r}"
  end

  class_methods do
    def defaults
      Rails.cache.fetch('blob_default/default') do
        BlobDefault.includes(:file_attachment).map do |i|
          ["#{i.record_class}_#{i.name}", i.file_attachment.blob_id]
        end.compact.to_h
      end
    end

    def cache_clear
      Rails.cache.delete('blob_default/private')
      Rails.cache.delete('blob_default/default')
    end
  end
end
