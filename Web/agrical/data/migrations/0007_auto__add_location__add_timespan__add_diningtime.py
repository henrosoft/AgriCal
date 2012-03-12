# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding model 'Location'
        db.create_table('data_location', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('location', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('data', ['Location'])

        # Adding M2M table for field timespans on 'Location'
        db.create_table('data_location_timespans', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('location', models.ForeignKey(orm['data.location'], null=False)),
            ('timespan', models.ForeignKey(orm['data.timespan'], null=False))
        ))
        db.create_unique('data_location_timespans', ['location_id', 'timespan_id'])

        # Adding model 'TimeSpan'
        db.create_table('data_timespan', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('days', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('type', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('span', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('data', ['TimeSpan'])

        # Adding model 'DiningTime'
        db.create_table('data_diningtime', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
        ))
        db.send_create_signal('data', ['DiningTime'])

        # Adding M2M table for field locations on 'DiningTime'
        db.create_table('data_diningtime_locations', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('diningtime', models.ForeignKey(orm['data.diningtime'], null=False)),
            ('location', models.ForeignKey(orm['data.location'], null=False))
        ))
        db.create_unique('data_diningtime_locations', ['diningtime_id', 'location_id'])


    def backwards(self, orm):
        
        # Deleting model 'Location'
        db.delete_table('data_location')

        # Removing M2M table for field timespans on 'Location'
        db.delete_table('data_location_timespans')

        # Deleting model 'TimeSpan'
        db.delete_table('data_timespan')

        # Deleting model 'DiningTime'
        db.delete_table('data_diningtime')

        # Removing M2M table for field locations on 'DiningTime'
        db.delete_table('data_diningtime_locations')


    models = {
        'data.busline': {
            'Meta': {'object_name': 'BusLine'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'line_tag': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'line_title': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'vehicles': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['data.BusVehicle']", 'symmetrical': 'False'})
        },
        'data.busvehicle': {
            'Meta': {'object_name': 'BusVehicle'},
            'dir_tag': ('django.db.models.fields.CharField', [], {'max_length': '10', 'null': 'True'}),
            'heading': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'predictable': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'route_tag': ('django.db.models.fields.CharField', [], {'max_length': '10'}),
            'seconds_since_report': ('django.db.models.fields.IntegerField', [], {}),
            'speed': ('django.db.models.fields.FloatField', [], {}),
            'vehicle_id': ('django.db.models.fields.IntegerField', [], {})
        },
        'data.diningtime': {
            'Meta': {'object_name': 'DiningTime'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'locations': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['data.Location']", 'symmetrical': 'False'})
        },
        'data.location': {
            'Meta': {'object_name': 'Location'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'timespans': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['data.TimeSpan']", 'symmetrical': 'False'})
        },
        'data.menu': {
            'Meta': {'ordering': "['-pub_date']", 'object_name': 'Menu'},
            'breakfast': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'breakfast'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'brunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'brunch'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'dinner': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'dinner'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'lunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'lunch'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'})
        },
        'data.menuitem': {
            'Meta': {'object_name': 'MenuItem'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'link': ('django.db.models.fields.CharField', [], {'default': "'#'", 'max_length': '1000'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "'Normal'", 'max_length': '50'})
        },
        'data.timespan': {
            'Meta': {'object_name': 'TimeSpan'},
            'days': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'span': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        }
    }

    complete_apps = ['data']
