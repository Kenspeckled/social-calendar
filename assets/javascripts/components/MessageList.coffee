#= require './Message'
{div, br, button, h2, p} = React.DOM
window.MessageList = React.createClass
  displayName: 'MessageList'
  render: ->
    div id: 'message-list',
      h2 null, 'Messages for ' + @props.date.format("MMMM Do")
      if _.isEmpty(@props.messages)
        p null, 'There arn\'t any Messages scheduled just yet.'
      else
        _.map @props.messages, (msg) =>
          return React.createElement Message, message: msg, showFormCallback: @props.showFormCallback
      br null
      button className: 'btn btn-primary', type: 'button', onClick: @props.showFormCallback, 'New Message!'

