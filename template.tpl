___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_lucida_analytics",
  "version": 1,
  "securityGroups": [],
  "displayName": "Lucida",
  "brand": {
    "id": "brand_dummy",
    "displayName": "Lucida"
  },
  "description": "Loads the Lucida browser snippet, initialises it with your project key, and sends custom events.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "tagType",
    "displayName": "Tag type",
    "macrosInSelect": false,
    "selectItems": [
      {"value": "init", "displayValue": "Initialise (load snippet, once per page)"},
      {"value": "event", "displayValue": "Send event"},
      {"value": "identify", "displayValue": "Identify (sign-in: attach the visitor to a user id)"},
      {"value": "alias", "displayValue": "Alias (link a second id to the visitor)"},
      {"value": "reset", "displayValue": "Reset (sign-out: forget the user)"},
      {"value": "optIn", "displayValue": "Opt in (consent granted)"},
      {"value": "optOut", "displayValue": "Opt out (consent withdrawn)"}
    ],
    "simpleValueType": true,
    "defaultValue": "init"
  },
  {
    "type": "TEXT",
    "name": "apiKey",
    "displayName": "Project API key (public key)",
    "simpleValueType": true,
    "valueValidators": [
      {"type": "NON_EMPTY"}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "init", "type": "EQUALS"}
    ],
    "help": "The public project key (starts with lc_pk_). Never put a secret key (lc_sk_) here."
  },
  {
    "type": "TEXT",
    "name": "apiHost",
    "displayName": "Ingest host",
    "simpleValueType": true,
    "defaultValue": "https://ingest.lucida.dev",
    "valueValidators": [
      {"type": "REGEX", "args": ["^https://.+"]}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "init", "type": "EQUALS"}
    ]
  },
  {
    "type": "TEXT",
    "name": "scriptUrl",
    "displayName": "Snippet URL",
    "simpleValueType": true,
    "defaultValue": "https://cdn.lucida.dev/lucida.js",
    "valueValidators": [
      {"type": "REGEX", "args": ["^https://cdn\\.lucida\\.dev/.+"]}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "init", "type": "EQUALS"}
    ],
    "help": "Self-hosting the snippet? Edit the inject_script permission to allow your host."
  },
  {
    "type": "SELECT",
    "name": "capturePageview",
    "displayName": "Pageviews",
    "macrosInSelect": false,
    "selectItems": [
      {"value": "history", "displayValue": "Initial load and SPA route changes"},
      {"value": "initial", "displayValue": "Initial load only"},
      {"value": "off", "displayValue": "None (send manually)"}
    ],
    "simpleValueType": true,
    "defaultValue": "history",
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "init", "type": "EQUALS"}
    ]
  },
  {
    "type": "SELECT",
    "name": "persistence",
    "displayName": "Persistence",
    "macrosInSelect": false,
    "selectItems": [
      {"value": "cookie", "displayValue": "Cookie"},
      {"value": "localStorage", "displayValue": "localStorage"},
      {"value": "memory", "displayValue": "Memory only"}
    ],
    "simpleValueType": true,
    "defaultValue": "cookie",
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "init", "type": "EQUALS"}
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "autocapture",
    "checkboxText": "Autocapture clicks, changes and submits",
    "simpleValueType": true,
    "defaultValue": true,
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "init", "type": "EQUALS"}
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "respectDnt",
    "checkboxText": "Respect Do Not Track",
    "simpleValueType": true,
    "defaultValue": true,
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "init", "type": "EQUALS"}
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "debug",
    "checkboxText": "Debug logging",
    "simpleValueType": true,
    "defaultValue": false,
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "init", "type": "EQUALS"}
    ]
  },
  {
    "type": "TEXT",
    "name": "userId",
    "displayName": "User id",
    "simpleValueType": true,
    "valueValidators": [
      {"type": "NON_EMPTY"}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "identify", "type": "EQUALS"}
    ],
    "help": "Your stable user id, usually a data layer variable. Do not use an email address unless you are allowed to."
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "personProps",
    "displayName": "Person properties ($set)",
    "simpleTableColumns": [
      {"defaultValue": "", "displayName": "Property", "name": "name", "type": "TEXT"},
      {"defaultValue": "", "displayName": "Value", "name": "value", "type": "TEXT"}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "identify", "type": "EQUALS"}
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "personPropsOnce",
    "displayName": "Person properties set once ($set_once)",
    "simpleTableColumns": [
      {"defaultValue": "", "displayName": "Property", "name": "name", "type": "TEXT"},
      {"defaultValue": "", "displayName": "Value", "name": "value", "type": "TEXT"}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "identify", "type": "EQUALS"}
    ]
  },
  {
    "type": "TEXT",
    "name": "aliasId",
    "displayName": "Alias",
    "simpleValueType": true,
    "valueValidators": [
      {"type": "NON_EMPTY"}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "alias", "type": "EQUALS"}
    ],
    "help": "The extra id to link to the current visitor."
  },
  {
    "type": "TEXT",
    "name": "aliasOriginal",
    "displayName": "Existing id (optional)",
    "simpleValueType": true,
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "alias", "type": "EQUALS"}
    ],
    "help": "Link the alias to this id instead of the current visitor."
  },
  {
    "type": "TEXT",
    "name": "eventName",
    "displayName": "Event name",
    "simpleValueType": true,
    "valueValidators": [
      {"type": "NON_EMPTY"}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "event", "type": "EQUALS"}
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "eventProps",
    "displayName": "Event properties",
    "simpleTableColumns": [
      {"defaultValue": "", "displayName": "Property", "name": "name", "type": "TEXT"},
      {"defaultValue": "", "displayName": "Value", "name": "value", "type": "TEXT"}
    ],
    "enablingConditions": [
      {"paramName": "tagType", "paramValue": "event", "type": "EQUALS"}
    ],
    "help": "Property names starting with $lc_ are reserved and dropped."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const createQueue = require('createQueue');
const injectScript = require('injectScript');
const makeTableMap = require('makeTableMap');
const log = require('logToConsole');

// The snippet drains window.lucidaQueue when it loads, so commands are safe to queue first.
const queue = createQueue('lucidaQueue');

// Property tables -> objects, minus the reserved $lc_ namespace.
function tableToProps(table) {
  const props = table ? makeTableMap(table, 'name', 'value') : {};
  for (const k in props) {
    if (k.indexOf('$lc_') === 0) {
      delete props[k];
    }
  }
  return props;
}

// Every tag except Initialise only queues a client command; the snippet runs it once the SDK is up.
let command = null;
switch (data.tagType) {
  case 'event':
    command = ['capture', data.eventName, tableToProps(data.eventProps)];
    break;
  case 'identify':
    command = ['identify', data.userId, tableToProps(data.personProps), tableToProps(data.personPropsOnce)];
    break;
  case 'alias':
    command = data.aliasOriginal ? ['alias', data.aliasId, data.aliasOriginal] : ['alias', data.aliasId];
    break;
  case 'reset':
  case 'optIn':
  case 'optOut':
    command = [data.tagType];
    break;
}
if (command) {
  queue(command);
  data.gtmOnSuccess();
  return;
}

const config = {
  apiHost: data.apiHost,
  capturePageview: data.capturePageview === 'off' ? false : data.capturePageview === 'initial' ? true : 'history',
  persistence: data.persistence,
  autocapture: !!data.autocapture,
  consent: {respectDnt: !!data.respectDnt},
  debug: !!data.debug
};
queue(['init', data.apiKey, config]);
if (data.debug) {
  log('Lucida: loading', data.scriptUrl);
}
injectScript(data.scriptUrl, data.gtmOnSuccess, data.gtmOnFailure, 'lucida-snippet');


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {"publicId": "inject_script", "versionId": "1"},
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {"type": 1, "string": "https://cdn.lucida.dev/*"}
            ]
          }
        }
      ]
    },
    "clientAnnotations": {"isEditedByUser": true},
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "access_globals", "versionId": "1"},
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {"type": 1, "string": "key"},
                  {"type": 1, "string": "read"},
                  {"type": 1, "string": "write"},
                  {"type": 1, "string": "execute"}
                ],
                "mapValue": [
                  {"type": 1, "string": "lucidaQueue"},
                  {"type": 8, "boolean": true},
                  {"type": 8, "boolean": true},
                  {"type": 8, "boolean": false}
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {"isEditedByUser": true},
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "logging", "versionId": "1"},
      "param": [
        {
          "key": "environments",
          "value": {"type": 1, "string": "debug"}
        }
      ]
    },
    "clientAnnotations": {"isEditedByUser": true},
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Event tag queues a capture command
  code: |-
    mock('createQueue', function(name) {
      return function(cmd) { assertThat(cmd[0]).isEqualTo('capture'); assertThat(cmd[1]).isEqualTo('signup'); };
    });
    runCode({tagType: 'event', eventName: 'signup', eventProps: []});
    assertApi('gtmOnSuccess').wasCalled();
- name: Identify tag queues identify with person properties
  code: |-
    mock('createQueue', function(name) {
      return function(cmd) {
        assertThat(cmd[0]).isEqualTo('identify');
        assertThat(cmd[1]).isEqualTo('user-1');
        assertThat(cmd[2]).isEqualTo({plan: 'pro'});
        assertThat(cmd[3]).isEqualTo({});
      };
    });
    runCode({tagType: 'identify', userId: 'user-1', personProps: [{name: 'plan', value: 'pro'}, {name: '$lc_x', value: 'no'}]});
    assertApi('gtmOnSuccess').wasCalled();
- name: Alias tag queues alias with and without an existing id
  code: |-
    const seen = [];
    mock('createQueue', function(name) { return function(cmd) { seen.push(cmd); }; });
    runCode({tagType: 'alias', aliasId: 'a1'});
    runCode({tagType: 'alias', aliasId: 'a2', aliasOriginal: 'o2'});
    assertThat(seen[0]).isEqualTo(['alias', 'a1']);
    assertThat(seen[1]).isEqualTo(['alias', 'a2', 'o2']);
- name: Reset and consent tags queue their command
  code: |-
    const seen = [];
    mock('createQueue', function(name) { return function(cmd) { seen.push(cmd[0]); }; });
    runCode({tagType: 'reset'});
    runCode({tagType: 'optIn'});
    runCode({tagType: 'optOut'});
    assertThat(seen).isEqualTo(['reset', 'optIn', 'optOut']);
- name: Init tag injects the snippet
  code: |-
    mock('createQueue', function(name) { return function(cmd) {}; });
    mock('injectScript', function(url, onSuccess) { onSuccess(); });
    runCode({tagType: 'init', apiKey: 'lc_pk_test', apiHost: 'https://ingest.lucida.dev', scriptUrl: 'https://cdn.lucida.dev/lucida.js', capturePageview: 'history', persistence: 'cookie'});
    assertApi('gtmOnSuccess').wasCalled();


___NOTES___

Created for Lucida (LC-INT-5). Requires a classic-script build of the browser SDK at the Snippet URL
that drains window.lucidaQueue (commands: ['init', apiKey, config], ['capture', name, props], and the client methods
identify, alias, reset, optIn and optOut).
