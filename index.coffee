'use strict';
util           = require 'util'
url            = require 'url'
_              = require 'lodash'
tinycolor      = require 'tinycolor2'
HueUtil        = require 'hue-util'
{EventEmitter} = require 'events'
debug          = require('debug')('meshblu-hue-light-extended')

MESSAGE_SCHEMA = require './messageSchema.json'

MESSAGE_FORM_SCHEMA = require './messageFormSchema.json'

OPTIONS_SCHEMA = require './optionsSchema.json'

ACTIONS_DEFAULTS = require './actionsDefaults.json'

ACTIONS_FORM = require './actionsForm.json'

class Plugin extends EventEmitter
  constructor: ->
    debug 'starting plugin'
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA
    @messageFormSchema = MESSAGE_FORM_SCHEMA
    @actions = ACTIONS_DEFAULTS
    @actionsForm = ACTIONS_FORM

  onMessage: (message) =>
    debug 'on message', message
    switch message.payload.action
      when 'custom' then payload = message.payload
      when 'set-color' then payload = {on: true, color:message.payload.color}
      else payload = @actions[message.payload.action]
    @updateHue payload

  onConfig: (device={}) =>
    debug 'on config', apikey: device.apikey
    @apikey = device.apikey || {}
    @setOptions device.options

  setOptions: (options={}) =>
    debug 'setOptions', options
    @options = _.extend apiUsername: 'octoblu', useGroup: false, options

    if @options.apiUsername != @apikey?.devicetype
      @apikey =
        devicetype: @options.apiUsername
        username: null

    @hue = new HueUtil @options.apiUsername, @options.ipAddress, @apikey?.username, @onUsernameChange

  onUsernameChange: (username) =>
    debug 'onUsernameChange', username
    @apikey.username = username
    @emit 'update', apikey: @apikey

  updateHue: (payload={}) =>
    debug 'updating hue', payload
    payload.lightNumber = @options.lightNumber
    payload.userGroup = @options.userGroup ? false
    return console.error 'no light number' unless payload.lightNumber?
    @hue.changeLights payload, (error, response) =>
      return @emit 'message', devices: ['*'], topic: 'error', payload: error: error if error?
      @emit 'message', devices: ['*'], payload: response: response

module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  messageFormSchema: MESSAGE_FORM_SCHEMA
  Plugin: Plugin
