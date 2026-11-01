___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_lucida_server",
  "version": 1,
  "securityGroups": [],
  "displayName": "Lucida (server)",
  "brand": {
    "id": "brand_dummy",
    "displayName": "Lucida"
  },
  "description": "Forwards events from a server-side GTM container (GA4 client event model) to Lucida.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "apiKey",
    "displayName": "Project API key",
    "simpleValueType": true,
    "valueValidators": [{"type": "NON_EMPTY"}],
    "help": "A secret key (lc_sk_) sends to /v1/s2s/batch and keeps event timestamps; a public key (lc_pk_) sends to /v1/batch. The server container is not visible to browsers, so a secret key is safe here."
  },
  {
    "type": "TEXT",
    "name": "apiHost",
    "displayName": "Ingest host",
    "simpleValueType": true,
    "defaultValue": "https://ingest.lucida.dev",
    "valueValidators": [{"type": "NON_EMPTY"}]
  },
  {
    "type": "TEXT",
    "name": "eventName",
    "displayName": "Event name override",
    "simpleValueType": true,
    "help": "Empty: use the incoming event_name (page_view becomes $pageview)."
  },
  {
    "type": "CHECKBOX",
    "name": "forwardAll",
    "checkboxText": "Forward every event parameter as a property",
    "simpleValueType": true,
    "defaultValue": true
  },
  {
    "type": "CHECKBOX",
    "name": "sendIp",
    "checkboxText": "Send the visitor IP (ip_override) as $ip (kept only when the project captures IPs)",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "extraProps",
    "displayName": "Extra properties",
    "simpleTableColumns": [
      {"defaultValue": "", "displayName": "Name", "name": "name", "type": "TEXT"},
      {"defaultValue": "", "displayName": "Value", "name": "value", "type": "TEXT"}
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const getAllEventData = require('getAllEventData');
const sendHttpRequest = require('sendHttpRequest');
const JSON = require('JSON');
const getTimestampMillis = require('getTimestampMillis');
const makeTableMap = require('makeTableMap');
const logToConsole = require('logToConsole');

const ev = getAllEventData();
// GA4 parameter -> Lucida property. Everything else is forwarded under its own name.
const renames = {
  page_location: '$current_url',
  page_referrer: '$referrer',
  page_title: '$title',
  screen_resolution: '$screen',
  language: '$browser_language',
  user_agent: '$raw_user_agent'
};
// Identity and transport fields never become properties.
const skip = {client_id: true, user_id: true, event_name: true, ip_override: true};

const props = {};
if (data.forwardAll) {
  for (const k in ev) {
    if (skip[k] || k.indexOf('x-') === 0) continue;
    props[renames[k] || k] = ev[k];
  }
} else {
  for (const k in renames) {
    if (ev[k] !== undefined) props[renames[k]] = ev[k];
  }
}
if (data.sendIp && ev.ip_override) {
  props['$ip'] = ev.ip_override;
}
const extra = data.extraProps ? makeTableMap(data.extraProps, 'name', 'value') : {};
for (const k in extra) {
  props[k] = extra[k];
}
// The reserved namespace is stripped by the gateway too; drop it here so the payload is honest.
for (const k in props) {
  if (k.indexOf('$lc_') === 0) delete props[k];
}

const distinctId = ev.user_id || ev.client_id;
if (!distinctId) {
  logToConsole('Lucida: event has neither user_id nor client_id; not sent');
  data.gtmOnFailure();
  return;
}
let name = data.eventName || ev.event_name;
if (name === 'page_view') name = '$pageview';

const secret = data.apiKey.indexOf('lc_sk_') === 0;
const host = data.apiHost.charAt(data.apiHost.length - 1) === '/' ? data.apiHost.slice(0, -1) : data.apiHost;
const url = host + (secret ? '/v1/s2s/batch' : '/v1/batch');
const body = {
  api_key: data.apiKey,
  batch: [{event: name, distinct_id: distinctId, timestamp: getTimestampMillis(), properties: props}]
};
sendHttpRequest(url, (statusCode) => {
  if (statusCode >= 200 && statusCode < 300) {
    data.gtmOnSuccess();
  } else {
    logToConsole('Lucida: HTTP ' + statusCode);
    data.gtmOnFailure();
  }
}, {headers: {'Content-Type': 'application/json'}, method: 'POST', timeout: 5000}, JSON.stringify(body));


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {"publicId": "read_event_data", "versionId": "1"},
      "param": [
        {"key": "eventDataAccess", "value": {"type": 1, "string": "any"}}
      ]
    },
    "clientAnnotations": {"isEditedByUser": true},
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "send_http", "versionId": "1"},
      "param": [
        {"key": "allowedUrls", "value": {"type": 1, "string": "any"}}
      ]
    },
    "clientAnnotations": {"isEditedByUser": true},
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "logging", "versionId": "1"},
      "param": [
        {"key": "environments", "value": {"type": 1, "string": "debug"}}
      ]
    },
    "clientAnnotations": {"isEditedByUser": true},
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Page view goes to s2s batch with mapped properties
  code: |-
    mock('getAllEventData', function() {
      return {event_name: 'page_view', client_id: 'c1', page_location: 'https://shop.example/a', ip_override: '1.2.3.4', 'x-ga-mp2-seg': '1', $lc_x: 'no'};
    });
    mock('sendHttpRequest', function(url, cb, opts, body) {
      assertThat(url).isEqualTo('https://ingest.lucida.dev/v1/s2s/batch');
      const ev = JSON.parse(body).batch[0];
      assertThat(ev.event).isEqualTo('$pageview');
      assertThat(ev.distinct_id).isEqualTo('c1');
      assertThat(ev.properties['$current_url']).isEqualTo('https://shop.example/a');
      assertThat(ev.properties['$ip']).isUndefined();
      assertThat(ev.properties['$lc_x']).isUndefined();
      assertThat(ev.properties['x-ga-mp2-seg']).isUndefined();
      cb(200);
    });
    runCode({apiKey: 'lc_sk_test', apiHost: 'https://ingest.lucida.dev/', forwardAll: true, sendIp: false});
    assertApi('gtmOnSuccess').wasCalled();
- name: User id wins, public key uses batch, IP only when enabled
  code: |-
    mock('getAllEventData', function() { return {event_name: 'purchase', client_id: 'c1', user_id: 'u9', ip_override: '1.2.3.4', value: 10}; });
    mock('sendHttpRequest', function(url, cb, opts, body) {
      assertThat(url).isEqualTo('https://ingest.lucida.dev/v1/batch');
      const ev = JSON.parse(body).batch[0];
      assertThat(ev.distinct_id).isEqualTo('u9');
      assertThat(ev.event).isEqualTo('order_completed');
      assertThat(ev.properties['$ip']).isEqualTo('1.2.3.4');
      assertThat(ev.properties.value).isUndefined();
      assertThat(ev.properties.plan).isEqualTo('pro');
      cb(202);
    });
    runCode({apiKey: 'lc_pk_test', apiHost: 'https://ingest.lucida.dev', eventName: 'order_completed', forwardAll: false, sendIp: true, extraProps: [{name: 'plan', value: 'pro'}]});
    assertApi('gtmOnSuccess').wasCalled();
- name: An event without user_id or client_id fails the tag
  code: |-
    mock('getAllEventData', function() { return {event_name: 'x'}; });
    runCode({apiKey: 'lc_pk_test', apiHost: 'https://ingest.lucida.dev'});
    assertApi('gtmOnFailure').wasCalled();
    assertApi('sendHttpRequest').wasNotCalled();


___NOTES___

Created for Lucida (LC-DX-41, G80). Install in a server container, trigger on the events your GA4
client claims. Events are sent one per tag firing; at-least-once delivery, the gateway dedupes by uuid.
