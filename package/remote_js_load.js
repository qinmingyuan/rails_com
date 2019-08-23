import Rails from '@rails/ujs'

const remote_js_load = (paths) => {
  if (Array.isArray(paths)) {
    for (i = 0; i < paths.length; i++) {
      Rails.ajax({url: paths[i], type: 'GET', dataType: 'script'})
    }
  } else if (typeof(paths) === 'string') {
    Rails.ajax({url: paths, type: 'GET', dataType: 'script'})
  }
}

module.exports = remote_js_load
