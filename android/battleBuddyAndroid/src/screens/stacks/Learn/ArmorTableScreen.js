import React, {useEffect, useState} from 'react';
import styled from 'styled-components/native';
import {FlatList} from 'react-native';
import LoadingIndicator from '../../../components/common/LoadingIndicator';
import {useBallistics} from '../../../context/BallisticsProvider';
import {useNavigation} from 'react-navigation-hooks';
import useCollection from '../../../hooks/useCollection';
import ItemType from '../../../constants/ItemType';
import getDescendantProp from '../../../utils/getDescendantProp';

const View = styled.View`
  background: ${({theme}) => theme.colors.almostBlack};
  flex: 1;
`;

const Header = styled.View`
  background: ${({theme}) => theme.colors.black};
  display: flex;
  flex-direction: row;
  padding: 20px 10px;
`;

const HeaderText = styled.Text`
  color: ${({active}) => (active ? 'white' : 'rgba(255, 255, 255, 0.5)')};
  text-align: center;
  width: 33%;
`;

const ItemText = styled.Text`
  color: white;
  text-align: center;
  width: 33%;
  padding: 14px 0;
`;

const ListItem = styled.TouchableOpacity`
  display: flex;
  flex-direction: row;
  align-items: center;
  text-align: center;
  border-bottom-color: rgba(255, 255, 255, 0.1);
  border-bottom-width: 1px;
  padding: 0 10px;
`;

const ArmorTableScreen = () => {
  const {setArmor} = useBallistics();
  const navigation = useNavigation();
  const {loading, data} = useCollection(ItemType.armor);
  const [sorted, setSorted] = useState({
    data: null,
    type: null,
    direction: 'ASC'
  });

  useEffect(() => {
    if (data) {
      sortByType('armor.class', 'DESC');
    }
  }, [data]);

  if (loading) return <LoadingIndicator />;

  const onPressHandler = (item) => {
    setArmor(item);
    navigation.goBack();
  };

  const sortByType = (type, direction) => {
    let sorted;

    if (direction === 'ASC') {
      sorted = data.sort((a, b) => {
        if (typeof getDescendantProp(a, type) === 'string') {
          return getDescendantProp(a, type).localeCompare(
            getDescendantProp(b, type)
          );
        } else {
          return getDescendantProp(a, type) - getDescendantProp(b, type);
        }
      });
    } else {
      sorted = data.sort((a, b) => {
        if (typeof getDescendantProp(a, type) === 'string') {
          return getDescendantProp(b, type).localeCompare(
            getDescendantProp(a, type)
          );
        } else {
          return getDescendantProp(b, type) - getDescendantProp(a, type);
        }
      });
    }

    setSorted({type, data: sorted, direction});
  };

  const types = [
    {label: 'Name', type: 'shortName'},
    {label: 'Class', type: 'armor.class'},
    {label: 'Durability', type: 'armor.durability'}
  ];

  return (
    <View>
      <Header>
        {types.map((x) => (
          <HeaderText
            key={x.type}
            onPress={() =>
              sortByType(x.type, sorted.direction === 'ASC' ? 'DESC' : 'ASC')
            }
            active={sorted.type === x.type}
          >
            {x.label}
          </HeaderText>
        ))}
      </Header>
      <FlatList
        data={sorted.data || data}
        keyExtractor={(item) => item._id}
        renderItem={({item}) => (
          <ListItem onPress={() => onPressHandler(item)}>
            <ItemText>{item.name}</ItemText>
            <ItemText>{item.armor.class}</ItemText>
            <ItemText>{item.armor.durability}</ItemText>
          </ListItem>
        )}
      />
    </View>
  );
};

ArmorTableScreen.navigationOptions = {
  title: 'Armor'
};

export default ArmorTableScreen;
