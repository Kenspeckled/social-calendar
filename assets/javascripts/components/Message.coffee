{div, p, span, h5, a, i} = React.DOM
window.Message = React.createClass
  displayName: 'Message'
  editMessage: ->
    @props.showFormCallback(@props.message)
  render: ->
    div className: 'message text-left',
      div className: 'time', moment(@props.message.time*1000).format("HH:mm")
      a className: 'edit', onClick: @editMessage, 'Edit'
      h5 null,
        i className: 'fa fa-'+@props.message.service
        span null, _.capitalize @props.message.service
      div null, @props.message.message

