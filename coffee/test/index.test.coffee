objelity = require('../')
{test} = require 'ava'

test 'deepKeys', (t) ->
  obj =
    a:
      b:
        c: [1,2,3]
      d: new Date()
    e:
      f:
        g: 'h'
  _keys = objelity.deepKeys(obj)
  t.deepEqual _keys, [
    'a.b.c.0',
    'a.b.c.1',
    'a.b.c.2',
    'a.d',
    'e.f.g',
  ]
  obj = [
    {name: 'alice', age: 17}
    {name: 'bob', age: 32}
    {name: 'charlie', age: 25}
  ]
  _keys = objelity.deepKeys(obj)
  t.deepEqual _keys, [
    '0.name',
    '0.age',
    '1.name',
    '1.age',
    '2.name',
    '2.age',
  ]
test 'commonPath(pathStrings)', (t) ->
  paths = [
    'a.b.c.d.e.f',
    'a.b.c.x.z',
    'a.b.c',
    'a.b.c.d.s',
  ]
  t.deepEqual objelity.commonPath(paths),['a','b','c']
test 'commonPath(pathArray)', (t) ->
  paths = [
    ['a','b','c','d','e']
    ['a','b','c','x','z','q']
    ['a','b','c','g','r']
    ['a','b','c','s']
    ['a','b','c']
  ]
  t.deepEqual objelity.commonPath(paths),['a','b','c']

test 'compactObject(obj)', (t) ->
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 0
      eee:
        fff: undefined
        ggg: null
      hhh:
        iii:
          jjj: true
  t.deepEqual objelity.compactObject(obj), {
    aaa:
      bbb:
        ccc: 1
        ddd: 0
      hhh:
        iii:
          jjj: true
  }

test 'flattenObject(obj)', (t) ->
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 0
      eee:
        fff: undefined
        ggg: null
      hhh:
        iii:
          jjj: true
  t.deepEqual objelity.flattenObject(obj), {
    aaa_bbb_ccc: 1,
    aaa_bbb_ddd: 0,
    aaa_eee_fff: undefined,
    aaa_eee_ggg: null,
    aaa_hhh_iii_jjj: true,
  }
test 'flattenObject(obj, separator)', (t) ->
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 0
      eee:
        fff: undefined
        ggg: null
      hhh:
        iii:
          jjj: true
  t.deepEqual objelity.flattenObject(obj, '-'), {
    'aaa-bbb-ccc': 1,
    'aaa-bbb-ddd': 0,
    'aaa-eee-fff': undefined,
    'aaa-eee-ggg': null,
    'aaa-hhh-iii-jjj': true,
  }
test 'eachObject(obj, fn)', (t) ->
  t.plan(4)
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 2
      eee:
        fff: 3
        ggg: 4
  objelity.eachObject obj, (val,path,index,object) ->
    if path.includes('aaa.bbb.ccc')
      t.is val, 1
    else if path.includes('aaa.bbb.ddd')
      t.is val, 2
    else if path.includes('aaa.eee.fff')
      t.is val, 3
    else if path.includes('aaa.eee.ggg')
      t.is val, 4
test 'mapObject(obj, fn) with sum', (t) ->
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 2
      eee:
        fff: 3
        ggg: 4
  newObj = objelity.mapObject obj, (val,path,index,object) ->
    return val * 2
  t.deepEqual newObj, {
    aaa:
      bbb:
        ccc: 2
        ddd: 4
      eee:
        fff: 6
        ggg: 8
  }

test 'mapObject(obj, fn) with returned array', (t) ->
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 0
      eee:
        fff: undefined
        ggg: null
  newObj = objelity.mapObject obj, (val,path,index,object) ->
    if path.match(/aaa\.bbb/)
      newPath = path.replace('aaa.bbb','xxx')
      return [newPath, val]
    else
      return [path, val]
  t.deepEqual newObj, {
    xxx:
      ccc: 1
      ddd: 0
    aaa:
      eee:
        fff: undefined
        ggg: null
  }

test 'mapObject(obj, fn) with returned object', (t) ->
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 0
      eee:
        fff: undefined
        ggg: null
  newObj = objelity.mapObject obj, (val,path,index,object) ->
    if path.match(/aaa\.bbb/)
      newPath = path.replace('aaa.bbb','xxx')
      return {[newPath]: val}
    else
      return {[path]: val}
  t.deepEqual newObj, {
    xxx:
      ccc: 1
      ddd: 0
    aaa:
      eee:
        fff: undefined
        ggg: null
  }

test 'toText(obj)', (t) ->
  obj = {a: 1}
  _t = objelity.toText(obj)
  t.not _t, '{"a": 1}'
  t.regex _t, /{\s{2,}"a": 1\n}/

test 'toText(arr)', (t) ->
  obj = [1,2,3]
  _t = objelity.toText(obj)
  t.not _t, '[1,2,3]'
  t.regex _t, /\[\n\s{2}1,\n\s{2}2,\n\s{2}3\s{1}\]/

test 'toText(fn)', (t) ->
  obj = => return true
  _t = objelity.toText(obj)
  t.regex _t, /\(\(\)\s=>\s{\n\s{6}return true;\n\s{4}}\)\(\)/

test 'toText(str)', (t) ->
  obj = 'str'
  _t = objelity.toText(obj)
  t.is _t, 'str'

test 'toText(num)', (t) ->
  obj = 123
  _t = objelity.toText(obj)
  t.is _t, '123'

test 'toText(undefined)', (t) ->
  obj = undefined
  _t = objelity.toText(obj)
  t.is _t, 'undefined'

test 'toText(null)', (t) ->
  obj = null
  _t = objelity.toText(obj)
  t.is _t, 'null'

test 'toText(true)', (t) ->
  obj = true
  _t = objelity.toText(obj)
  t.is _t, 'true'

test 'toText(NaN)', (t) ->
  obj = NaN
  _t = objelity.toText(obj)
  t.is _t, 'NaN'

test 'rejectObject(obj, fn)', (t) ->
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 2
      eee:
        fff: 3
        ggg: 4
  newObj = objelity.rejectObject obj, (val, path, index, object) ->
    return val % 2 is 0
  t.deepEqual newObj, {
    aaa:
      bbb:
        ccc: 1
      eee:
        fff: 3
  }
test 'rejectObject(obj, array)', (t) ->
  obj =
    a: 1
    b: 2
    c: 3
  t.deepEqual objelity.rejectObject(obj, ['b']), {a:1, c:3}
test 'rejectObject(obj, nestedArray)', (t) ->
  obj =
    a:
      aa: 11
      bb: 22
    b: 2
    c: 3
  t.deepEqual objelity.rejectObject(obj, ['a']), {b:2, c:3}
  t.deepEqual objelity.rejectObject(obj, ['a.b','c']), {a:{aa:11}, b:2}
test 'filterObject(obj, fn)', (t) ->
  obj =
    aaa:
      bbb:
        ccc: 1
        ddd: 2
      eee:
        fff: 3
        ggg: 4
  newObj = objelity.filterObject obj, (val, path, index, object) ->
    return val % 2 is 0
  t.deepEqual newObj, {
    aaa:
      bbb:
        ddd: 2
      eee:
        ggg: 4
  }
test 'filterObject(obj, array)', (t) ->
  obj =
    a: 1
    b: 2
    c: 3
  t.deepEqual objelity.filterObject(obj, ['a','c']), {a:1, c:3}

test 'filterObject(obj, nestedArray)', (t) ->
  obj =
    a:
      aa: 11
      bb: 22
    b: 2
    c: 3
  t.deepEqual objelity.filterObject(obj, ['a','c']), {a:{aa:11, bb:22}, c:3}
  t.deepEqual objelity.filterObject(obj, ['a.b','c']), {a:{bb:22}, c:3}

test 'to string of deep keys', (t) ->
  obj =
    str: 'string1'
    num: 123
    arr:[
      true,
      false
      undefined
    ]
    o:
      sym: Symbol("foo")
      nil: null
      fn: (-> false)
  newObj = objelity.toStringOfDeepKeys(obj)
  t.deepEqual newObj,{
    str: 'string1'
    num: '123'
    arr:[
      'true',
      'false'
      'undefined'
    ]
    o:
      sym: 'Symbol(foo)'
      nil: 'null'
      fn: "function () {\n          return false;\n        }"
  }
