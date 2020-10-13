import { Controller } from 'stimulus'

// data-controller="common"
class CommonController extends Controller {

  connect() {
    console.debug('Common Controller works!')
  }

  cancel(event) {
    event.preventDefault()
    Turbolinks.visit(location.href, { action: 'replace' })
  }

}

application.register('common', CommonController)