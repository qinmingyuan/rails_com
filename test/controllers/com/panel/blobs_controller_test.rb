require 'test_helper'
class Com::Panel::BlobsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @blob = create :active_storage_blob
  end

  test 'index ok' do
    get panel_blobs_url
    assert_response :success
  end

  test 'new ok' do
    get new_panel_blob_url, xhr: true
    assert_response :success
  end

  test 'create ok' do
    io = Rack::Test::UploadedFile.new File.join(self.class.file_fixture_path, 'empty_file.txt')
    assert_difference('ActiveStorage::Blob.count') do
      post panel_blobs_url, params: { blob: { io: io } }, xhr: true
    end

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('ActiveStorage::Blob.count', -1) do
      delete panel_blob_url(@blob), xhr: true
    end

    assert_response :success
  end
end
