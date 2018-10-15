Object + Utility

# objelity



## api
---
### deepKeys(obj)
---

object内すべてのdeepKey(path)を取得します。

#### Since
1.0.0

#### Arguments
Object (Object | Array)

#### Returns
Array

#### Example

```js
var _keys, obj;
obj = {
  a: {
    b: {
      c: [1, 2, 3]
    },
    d: new Date()
  },
  e: {
    f: {
      g: 'h'
    }
  }
};
objelity.deepKeys(obj);
// => ['a.b.c.0', 'a.b.c.1', 'a.b.c.2', 'a.d', 'e.f.g']
```

```js
obj = [
  {
    name: 'alice',
    age: 17
  },
  {
    name: 'bob',
    age: 32
  },
  {
    name: 'charlie',
    age: 25
  }
];
objelity.deepKeys(obj);
// => ['0.name', '0.age', '1.name', '1.age', '2.name', '2.age']
```

---
### compactObject(obj)
---

objectから値が`null`と`undefined`の要素を除去します

#### Since
1.0.0

#### Arguments
Object (Object | Array)

#### Returns
Object

#### Example

```js
var obj;
obj = {
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 0
    },
    eee: {
      fff: undefined,
      ggg: null
    },
    hhh: {
      iii: {
        jjj: true
      }
    }
  }
};
objelity.compactObject(obj);
// =>
{
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 0
    },
    hhh: {
      iii: {
        jjj: true
      }
    }
  }
}
```

---
### flattenObject(obj, separator)
---

objectをflatten(フラット化)します

#### Since
1.0.0

#### Arguments
Object (Object | Array)

#### Returns
Object

#### Example

```js
var obj;
obj = {
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 0
    },
    eee: {
      fff: void 0,
      ggg: null
    },
    hhh: {
      iii: {
        jjj: true
      }
    }
  }
};
objelity.flattenObject(obj);
// =>
{
  aaa_bbb_ccc: 1,
  aaa_bbb_ddd: 0,
  aaa_eee_fff: void 0,
  aaa_eee_ggg: null,
  aaa_hhh_iii_jjj: true
}

objelity.flattenObject(obj, '-'); 
// =>
{
  'aaa-bbb-ccc': 1,
  'aaa-bbb-ddd': 0,
  'aaa-eee-fff': void 0,
  'aaa-eee-ggg': null,
  'aaa-hhh-iii-jjj': true
}
```

---
### eachObject(obj, fn)
---

objectのすべての要素をイテレートします。

#### Since
1.0.0

#### Arguments
Object (Object | Array)
callback (val, path, index, object)

#### Returns
void

#### Example

```js
var obj;
obj = {
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 2
    },
    eee: {
      fff: 3,
      ggg: 4
    }
  }
};
objelity.eachObject(obj, function(val, path, index, object) {
  console.log(val, path, index);
});

// =>
1 'aaa.bbb.ccc' 0
2 'aaa.bbb.ddd' 1
3 'aaa.eee.fff' 2
4 'aaa.eee.ggg' 3
```

---
### mapObject(obj, fn)
---

objectのすべての要素をイテレートします。

#### Since
1.0.0

#### Arguments
Object (Object | Array)
callback (val, path, index, object)

#### Returns
Array

#### Example

```js
// changing values
var obj;
obj = {
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 2
    },
    eee: {
      fff: 3,
      ggg: 4
    }
  }
};
objelity.mapObject(obj, function(val, path, index, object) {
  return val * 2;
});
// =>
{
  aaa: {
    bbb: {
      ccc: 2,
      ddd: 4
    },
    eee: {
      fff: 6,
      ggg: 8
    }
  }
}
```

```js
// returning array
var obj;
obj = {
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 0
    },
    eee: {
      fff: void 0,
      ggg: null
    }
  }
};
objelity.mapObject(obj, function(val, path, index, object) {
  var newPath;
  if (path.match(/aaa\.bbb/)) {
    newPath = path.replace('aaa.bbb', 'xxx');
    return [newPath, val];
  } else {
    return [path, val];
  }
});
// =>
{
  xxx: {
    ccc: 1,
    ddd: 0
  },
  aaa: {
    eee: {
      fff: void 0,
      ggg: null
    }
  }
})
```

```js
// returning an object
var obj;
obj = {
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 0
    },
    eee: {
      fff: void 0,
      ggg: null
    }
  }
};
objelity.mapObject(obj, function(val, path, index, object) {
  var newPath;
  if (path.match(/aaa\.bbb/)) {
    newPath = path.replace('aaa.bbb', 'xxx');
    return {
      [newPath]: val
    };
  } else {
    return {
      [path]: val
    };
  }
});
// =>
{
  xxx: {
    ccc: 1,
    ddd: 0
  },
  aaa: {
    eee: {
      fff: void 0,
      ggg: null
    }
  }
})
```

---
### toText(val)
---

toStringの変形です。objectの場合は`JSON.stringify`します。

#### Since
1.0.0

#### Arguments
val (any)

#### Returns
string

#### Example

```js
objelity.toText({a: 1});
// => The return value is a string
// {
//   "a": 1
// }

objelity.toText([1, 2, 3]);
// => The return value is a string
// [
//   1,
//   2,
//   3
// ]

objelity.toText(() => {return true;};);
// => The return value is a string
// (() => {
//   return true;
// })()

objelity.toText('str');
// => The return value is a string
// 'str'

objelity.toText(123);
// => The return value is a string
// '123'

objelity.toText(undefined);
// => The return value is a string
// 'undefined'

objelity.toText(null);
// => The return value is a string
// 'null'

objelity.toText(true);
// => The return value is a string
// 'true'

objelity.toText(0/0);
// => The return value is a string
// 'NaN'
```

---
### filterObject(obj, fn)
---

objectのすべての要素をイテレートします。
callbackで真の値を返した要素を抽出します。
新しいobjectを返します。

#### Since
1.0.0

#### Arguments
Object (Object | Array)
callback (val, path, index, object)

#### Returns
Object

#### Example

```js
var obj = {
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 2
    },
    eee: {
      fff: 3,
      ggg: 4
    }
  }
};
objelity.filterObject(obj, function(val, path, index, object) {
  return val % 2 === 0;
});
// =>
aaa: {
  bbb: {
    ddd: 2
  },
  eee: {
    ggg: 4
  }
}
```

```js
obj = {
  a: {
    aa: 11,
    bb: 22
  },
  b: 2,
  c: 3
};
objelity.rejectObject(obj, ['a','c'])
// => short hand for path 'a' and 'c'
{
  a: {
    aa: 11,
    bb: 22
  },
  c: 3
}
objelity.rejectObject(obj, ['a.b', 'c'])
// => path 'a.b' is included in 'a.bb'
{
  a: {
    bb: 22
  },
  c: 3
}
```

---
### rejectObject(obj, fn)
---

objectのすべての要素をイテレートします。
callbackで真の値を返した要素を削除します。
新しいobjectを返します。

#### Since
1.0.0

#### Arguments
Object (Object | Array)
callback (val, path, index, object)

#### Returns
Object

#### Example

```js
var obj = {
  aaa: {
    bbb: {
      ccc: 1,
      ddd: 2
    },
    eee: {
      fff: 3,
      ggg: 4
    }
  }
};
objelity.rejectObject(obj, function(val, path, index, object) {
  return val % 2 === 0;
});
// =>
{
  aaa: {
    bbb: {
      ccc: 1
    },
    eee: {
      fff: 3
    }
  }
})
```

```js
obj = {
  a: {
    aa: 11,
    bb: 22
  },
  b: 2,
  c: 3
};
objelity.rejectObject(obj, ['a'])
// => short hand for path 'a'
{
  b: 2,
  c: 3
}
objelity.rejectObject(obj, ['a.b', 'c'])
// => path 'a.b' is included in 'a.bb'
{
  a: {
    aa: 11
  },
  b: 2
})
```

---
### stringify(obj, replacer, space)
---

通常の`JSON.stringify`に加えて複数の項目もstringifyします。

#### Since
1.1.0

#### Arguments
Object (Any)
replacer (fanction (key, value))
space (Number | String)

#### Returns
String

#### Example

```js
obj = {
  undefined: void 0,
  function: function() {
    return true;
  },
  generator: function*() {
    return (yield 0);
  },
  RegExp: /foo/,
  newReg: new RegExp('foo'),
  err: new Error('unknown error'),
  NaN: 0 / 0
};
JSON.stringify(obj, null, 2);
// =>
// {
//   NaN: null,
//   RegExp: {},
//   err: {},
//   newReg: {},
// }

objelity.stringify(obj, null, 2);

// =>
// {
//   NaN: '[object Number] NaN',
//   RegExp: '[object RegExp] /foo/',
//   err: '[object Error] Error: unknown error',
//   function: `(function () {␊
//           return true;␊
//         }()`,
//   generator: `(function* () {␊
//           return yield 0;␊
//         }()`,
//   newReg: '[object RegExp] /foo/',
//   undefined: '[object Undefined] undefined',
}
```