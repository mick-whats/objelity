_ = require 'lodash'


objelity =
  deepKeys: (obj)->
    # result = []
    first = true
    _depth = []
    next = true
    while next
      if first
        _depth.push(Object.keys(obj))
        first = false
      _keys = _.last(_depth)
      _halfway = []
      next = false
      _keys.forEach (key)->
        _halfObj = _.get(obj,key)
        if _.isPlainObject(_halfObj) or _.isArray(_halfObj)
          next = true
          _arr = Object.keys(_halfObj).map (childKey)->
            return "#{key}.#{childKey}"
          _halfway.push(_arr)
        else
          _halfway.push(key)
      _depth.push(_.flatten _halfway)
    return _.last(_depth)

  commonPath: (paths)->
    pathArray = paths.map (path)->
      if _.isString(path)
        return _.toPath(path)
      return path
    result = []
    pathArray[0].some (s,columnIndex)->
      rows = pathArray.map (row)-> row[columnIndex]
      if rows.every((row)-> row is s)
        result.push(s)
        return false
      else
        return true
    return result

  compactObject: (obj)->
    _paths = objelity.deepKeys(obj)
    newObj = {}
    _paths.forEach (p)->
      val = _.get(obj,p)
      if _.isNil(val)
        return
      else
        _.set(newObj,p,val)
        return
    return newObj

  flattenObject: (obj, separator='_')->
    _paths = objelity.deepKeys(obj)
    newObj = {}
    _paths.forEach (p)->
      val = _.get(obj,p)
      _newPath = p.replace(/\./g,separator)
      _.set(newObj,_newPath,val)
    return newObj

  eachObject: (obj, fn)->
    _paths = objelity.deepKeys(obj)
    _paths.forEach (p,i)->
      val = _.get(obj,p)
      fn(val, p, i, obj)
      return
    return

  mapObject: (obj, fn)->
    _paths = objelity.deepKeys(obj)
    newObj = {}
    _paths.forEach (p,i)->
      val = _.get(obj,p)
      resArr = fn(val, p, i, obj)
      if _.isArray(resArr)
        if resArr.length > 1
          _.set(newObj,resArr[0],resArr[1])
        else
          _.set(newObj,p,resArr)
      else if _.isPlainObject(resArr)
        key = Object.keys(resArr)[0]
        val = resArr[key]
        _.set(newObj, key, val)
      else
        _.set(newObj,p,resArr)
    return newObj

  toText: (obj)->
    switch typeof obj
      when 'object'
        JSON.stringify(obj,null,2)
      when 'undefined'
        'undefined'
      when 'function'
        "(#{obj.toString()})()"
      else
        obj.toString()

  rejectObject: (obj, fn)->
    newObj = objelity.mapObject obj, (val, p, i, obj)->
      if _.isFunction(fn)
        if fn(val, p, i, obj) then null else val
      else if _.isArray(fn)
        flag = fn.some (_path)->
          return if _.startsWith(p, _path) then true else false
        return if flag then null else val
      else
        return null
    objelity.compactObject(newObj)

  filterObject: (obj, fn)->
    newObj = objelity.mapObject obj, (val, p, i, obj)->
      if _.isFunction(fn)
        if fn(val, p, i, obj) then val else null
      else if _.isArray(fn)
        flag = fn.some (_path)->
          return if _.startsWith(p, _path) then true else false
        return if flag then val else null
      else
        return null
    objelity.compactObject(newObj)
  toStringOfDeepKeys: (obj)->
    objelity.mapObject obj, (val, p, i, obj)->
      switch typeof val
        when 'undefined'
          Object::toString.call(val)
        when 'function'
          val.toString()
        when 'boolean', 'number'
          val
        else
          if _.isNull(val)
            Object::toString.call(val)
          else
            val.toString()
  stringify: (obj, replacer, space=null)->
    unless replacer
      replacer = (key, value)->
        switch on
          when _.isError(value)
            # "#{value}"
            Object::toString.call(value) + " #{value}"
          when _.isRegExp(value)
            # "#{value}"
            Object::toString.call(value) + " #{value}"
          when _.isNaN(value)
            "[object Number] NaN"
          when _.isUndefined(value)
            "undefined"
            Object::toString.call(value) + " #{value}"
          when _.isFunction(value)
            "(#{value.toString()}()"
          else
            value
    JSON.stringify(obj,replacer,space)
module.exports = objelity