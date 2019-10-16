import React from 'react';
import {createStackNavigator} from 'react-navigation-stack';
import ItemsScreen from '../screens/ItemsScreen';
import TabBarIcon from '../components/common/TabBarIcon';
import CategoryScreen from '../screens/CategoryScreen';
import ItemDetailScreen from '../screens/stacks/Item/ItemDetailScreen';
import SearchScreen from '../screens/SearchScreen';
import SelectCompareScreen from '../screens/stacks/Item/SelectCompareScreen';
import ComparisonScreen from '../screens/stacks/Item/ComparisonScreen';

const itemsNavigator = createStackNavigator({
  Items: ItemsScreen,
  Compare: ComparisonScreen,
  SelectCompare: SelectCompareScreen,
  Category: CategoryScreen,
  Detail: ItemDetailScreen,
  Search: SearchScreen
});

itemsNavigator.navigationOptions = {
  tabBarLabel: 'Items',
  tabBarIcon: ({focused}) => <TabBarIcon focused={focused} name="items" /> // eslint-disable-line
};

export default itemsNavigator;
