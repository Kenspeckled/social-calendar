#= require './Message'
{div, br, button} = React.DOM
window.MessageList = React.createClass
  displayName: 'MessageList'
  render: ->
    div id: 'message-list',
      _.map @props.messages, (msg) ->
        return React.createElement Message, message: msg
      br null
      button className: 'btn btn-primary', type: 'button', onClick: @props.showFormCallback, 'New Message!'

