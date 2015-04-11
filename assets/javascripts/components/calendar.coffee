#= require './calendarDay'
{div, span, i, nav, h2, h3} = React.DOM

window.Calendar = React.createClass
  displayName: 'Calendar'

  getInitialState: ->
    date = moment()
    dayRows = @getDayRows(date)
    dayMessages = {} 
    {date, dayRows, dayMessages}

  nextMonth: ->
    date = @state.date.clone().add(1, 'month')
    dayRows = @getDayRows(date)
    @setState {date, dayRows}

  prevMonth: ->
    date = @state.date.clone().subtract(1, 'month')
    dayRows = @getDayRows(date)
    @setState {date, dayRows}

  getDayRows: (currentDate) ->
    startOfMonth = moment(currentDate).clone().startOf('month')
    @getMessagesForMonth(startOfMonth)
    dayArray = []
    daysInMonth = currentDate.daysInMonth()
    startingBlankDays = if startOfMonth.day() > 0 then startOfMonth.day() - 1 else 6
    endingBlankDays = if ((daysInMonth + startingBlankDays) % 7) then 7 - ((daysInMonth + startingBlankDays) % 7) else 0
    _.times startingBlankDays, ->
      dayArray.push(null)
    _.times daysInMonth, (d) =>
      day = currentDate.clone().date(d+1)
      day.startOf 'day'
      day.year currentDate.year()
      dayArray.push day
    _.times endingBlankDays, ->
      dayArray.push(null)
    dayRows = _.chunk(dayArray, 7)
    dayRows

  getMessagesForMonth: (date) ->
    dateString = moment(date).format("YYYY-MM")
    p = new Promise (resolve, reject) ->
      r = new XMLHttpRequest
      r.addEventListener 'readystatechange', ->
        if r.readyState == 4 and r.status == 200
          resolve(r.responseText)
      r.open 'GET', '/messages/month/'+dateString, true
      r.send()  
    p.then (response) =>
      data = JSON.parse(response)
      dayMessages = []
      _.each data.messages, (message) =>
        @setState (state, props) ->
          message.time = +moment(+message.time)*1000 # convert to miliseconds
          d = moment(+message.time).format("YYYY-MM-DD")
          dayMessages[d] = [] if !_.has(state.dayMessages, d)
          dayMessages[d].push message
          state.dayMessages = dayMessages
          return state  
      console.log @state

  render: ->
    div className: 'custom-calendar-wrap',
      div className: 'custom-inner', 
        div id: 'calendar-overlay-container'
        div className: 'custom-header clearfix',
          nav null,
            i className: 'fa fa-arrow-left', onClick: @prevMonth
            i className: 'fa fa-arrow-right', onClick: @nextMonth
          h2 className: 'custom-month', @state.date.format('MMMM')
          h3 className: 'custom-year', @state.date.format('YYYY')
        div className: 'calendar fc-calendar-container',
          div className: 'fc-calendar ' + (if @state.dayRows.length == 6 then 'fc-six-rows' else 'fc-five-rows') ,
            div className: 'fc-head',
              div null, 'Mon'
              div null, 'Tue'
              div null, 'Wed'
              div null, 'Thu'
              div null, 'Fri'
              div null, 'Sat'
              div null, 'Sun'
            div className: 'fc-body',
              _.map @state.dayRows, (row) =>
                return div className: 'fc-row',
                  _.map row, (day) =>
                    if !day
                      return div null
                    else
                      return React.createElement CalendarDay, date: day, messages: @state.dayMessages[day.format("YYYY-MM-DD")]
