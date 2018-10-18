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
test 'commonPath(pathStrings)', (t) ->
  paths = [
    'a.b.c.d.e.f',
    'd.e.f',
  ]
  t.deepEqual objelity.commonPath(paths),[]
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
    return
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
    num: 123
    arr:[
      true
      false
      '[object Undefined]'
    ]
    o:
      sym: 'Symbol(foo)'
      nil: '[object Null]'
      fn: "function () {\n          return false;\n        }"
  }

getObject = ->
  {
    num: 123
    str: 'string'
    bool1: true
    bool2: false
    nul: null
    und: undefined
    arr: ['a','r','r']
    buf: new Buffer('')
    fn: -> true
    gfn: -> yield 0
    args: arguments
    obcr: Object.create(null)
    date: new Date(Date.UTC(2018,9,15))
    reg: /foo/
    newreg: new RegExp('foo')
    err: new Error('unknown error')
    symbol: Symbol('str')
    map: new Map([['a',1],['b',2]])
    weakMap: new WeakMap()
    set: new Set([1,2,'3'])
    weakSet: new WeakSet()
    int8Array: new Int8Array([1,9876543210,-9876543210])
    uint8Array: new Uint8Array([1,9876543210,-9876543210])
    uint8ClampedArray: new Uint8ClampedArray([1,9876543210,-9876543210])
    int16Array: new Int16Array([1,9876543210,-9876543210])
    uint16Array: new Uint16Array([1,9876543210,-9876543210])
    int32Array: new Int32Array([1,9876543210,-9876543210])
    uint32Array: new Uint32Array([1,9876543210,-9876543210])
    float32Array: new Float32Array([1,9876543210,-9876543210])
    float64Array: new Float64Array([1,9876543210,-9876543210])
    nan: 0/0
  }

test 'stringify diff', (t) ->
  a = objelity.stringify(getObject(999),null,2)
  aa = JSON.parse(a)
  c = JSON.stringify(getObject(999),null,2)
  cc = JSON.parse(c)
  t.notDeepEqual aa,cc
  t.snapshot a
  t.snapshot c

test 'stringify primitive', (t) ->
  t.is objelity.stringify('str'), '"str"'
  t.is objelity.stringify(123), '123'
  t.is objelity.stringify(true), 'true'
  t.is objelity.stringify(false), 'false'
  t.is objelity.stringify(null), 'null'
  t.is objelity.stringify(undefined), '"[object Undefined] undefined"'
  t.is objelity.stringify(NaN), '"[object Number] NaN"'
  t.is objelity.stringify([1,2,3]), '[1,2,3]'

test 'stringify readme', (t) ->
  obj =
    undefined: undefined
    function: -> true
    generator: -> yield 0
    RegExp: /foo/
    newReg: new RegExp('foo')
    err: new Error('unknown error')
    # symbol: Symbol('str')
    # map: new Map([['a',1],['b',2]])
    # weakMap: new WeakMap()
    # set: new Set([1,2,'3'])
    # weakSet: new WeakSet()
    NaN: 0/0
  a = objelity.stringify(obj,null,2)
  aa = JSON.parse(a)
  c = JSON.stringify(obj,null,2)
  cc = JSON.parse(c)
  t.snapshot aa
  t.snapshot cc