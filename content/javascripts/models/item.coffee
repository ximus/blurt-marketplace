class window.Item
  title: null,
  image_url: null,
  description: null,
  short_desc: null,
  end_date: null,

  # NOTE: This doesn't refresh on end_date change
  getTimeLeft: =>
    @_difference ?= Date.timeDifference(@end_date, new Date(Date.now()))  