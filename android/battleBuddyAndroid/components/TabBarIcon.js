import React from 'react';
import { Image, StyleSheet } from 'react-native';

import Colors from '../constants/Colors';

export default function TabBarIcon(props) {
  var icon;
  switch(props.name){
    case 'items':
      icon = require('../assets/images/items.png');
      break;
    case 'learn':
      icon = require('../assets/images/learn.png');
      break;
    case 'more':
      icon = require('../assets/images/more.png');
      break;
    default:
      return;
  }

  return (
    <Image
      style={[styles.iconBase, props.focused && styles.selectedIcon]}
      source={icon}
    />
  );
}

const styles = StyleSheet.create({
  iconBase: {
    marginBottom: -3,
    transform: [{
      scale: 0.5
    }],
    tintColor: Colors.tabIconDefault,
  },
  selectedIcon: {
    tintColor: Colors.tabIconSelected
  }
});