App.Api = DS.Model.extend
  name: DS.attr('string')
  installUrl: DS.attr('string')
  uninstallUrl: DS.attr('string')
  isActive: DS.attr('boolean', defaultValue: false)
  resources: DS.hasMany('resource')
