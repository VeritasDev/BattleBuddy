import React from 'react';
import PropTypes from 'prop-types';
import DetailSection from './DetailSection';
import {useNavigation} from 'react-navigation-hooks';
import ItemType from '../../constants/ItemType';
import localeString from '../../utils/localeString';

const MedicalDetail = ({item}) => {
  const {navigate} = useNavigation();

  let medicalData = [];
  switch (item.type) {
    case 'medkit':
      medicalData = [
        {
          title: 'Properties',
          rows: [
            {key: 'Type', value: localeString(item.type)},
            {key: 'Total HP', value: item.resources},
            {key: 'Use Time', value: item.useTime},
            {
              key: 'Removes Blood Loss',
              value: item.effects.bloodloss ? 'Yes' : 'No'
            },
            {
              key: 'Removes Contusion',
              value: item.effects.contusion ? 'Yes' : 'No'
            },
            {
              key: 'Removes Fracture',
              value: item.effects.fracture ? 'Yes' : 'No'
            },
            {
              key: 'Compare',
              onPress: () =>
                navigate('SelectCompare', {
                  selectedItem: item,
                  itemType: ItemType.medical
                })
            }
          ]
        }
      ];
      break;
    case 'drug':
      medicalData = [
        {
          title: 'Properties',
          rows: [
            {key: 'Type', value: 'Painkiller'},
            {key: '# of Uses', value: item.resources || 1},
            {key: 'Use Time', value: item.useTime},
            {
              key: 'Effect Duration',
              value: item.effects.pain.duration
            },
            {
              key: 'Removes Pain',
              value: item.effects.pain ? 'Yes' : 'No'
            },
            {
              key: 'Removes Blood Loss',
              value: item.effects.bloodloss ? 'Yes' : 'No'
            },
            {
              key: 'Removes Contusion',
              value: item.effects.contusion ? 'Yes' : 'No'
            },
            {
              key: 'Removes Fracture',
              value: item.effects.fracture ? 'Yes' : 'No'
            },
            {
              key: 'Compare',
              onPress: () =>
                navigate('SelectCompare', {
                  selectedItem: item,
                  itemType: ItemType.medical
                })
            }
          ]
        }
      ];
      break;
    case 'accessory':
      medicalData = [
        {
          title: 'Properties',
          rows: [
            {key: 'Type', value: localeString(item.type)},
            {key: '# of Uses', value: item.resources || 1},
            {key: 'Use Time', value: item.useTime},
            {
              key: 'Removes Pain',
              value: item.effects.pain ? 'Yes' : 'No'
            },
            {
              key: 'Removes Blood Loss',
              value: item.effects.bloodloss ? 'Yes' : 'No'
            },
            {
              key: 'Removes Contusion',
              value: item.effects.contusion ? 'Yes' : 'No'
            },
            {
              key: 'Removes Fracture',
              value: item.effects.fracture ? 'Yes' : 'No'
            },
            {
              key: 'Compare',
              onPress: () =>
                navigate('SelectCompare', {
                  selectedItem: item,
                  itemType: ItemType.medical
                })
            }
          ]
        }
      ];
      break;
    case 'stimulator':
      medicalData = [
        {
          title: 'Properties',
          rows: [
            {key: 'Type', value: localeString(item.type)},
            {key: '# of Uses', value: item.resources || 1},
            {key: 'Use Time', value: item.useTime},
            {
              key: 'Effect Duration',
              value: item.effects.pain.duration
            },
            {
              key: 'Removes Pain',
              value: item.effects.pain ? 'Yes' : 'No'
            },
            {
              key: 'Removes Blood Loss',
              value: item.effects.bloodloss ? 'Yes' : 'No'
            },
            {
              key: 'Removes Contusion',
              value: item.effects.contusion ? 'Yes' : 'No'
            },
            {
              key: 'Removes Fracture',
              value: item.effects.fracture ? 'Yes' : 'No'
            },
            {
              key: 'Compare',
              onPress: () =>
                navigate('SelectCompare', {
                  selectedItem: item,
                  itemType: ItemType.medical
                })
            }
          ]
        }
      ];
      break;
  }

  return medicalData.map((d) => <DetailSection key={d.title} section={d} />);
};

MedicalDetail.propTypes = {
  item: PropTypes.object.isRequired
};

export default MedicalDetail;
