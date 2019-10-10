import React from 'react';
import PropTypes from 'prop-types';
import DetailSection from './DetailSection';

const MedicalDetail = ({item}) => {
  let medicalData = [];

  switch (item.type) {
    case 'medkit':
      medicalData = [
        {
          title: 'Properties',
          rows: [
            {key: 'Type', value: item.type, hideChevron: true},
            {key: 'Total HP', value: item.resources, hideChevron: true},
            {key: 'Use Time', value: item.useTime, hideChevron: true},
            {
              key: 'Removes Blood Loss',
              value: item.effects.bloodloss ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Contusion',
              value: item.effects.contusion ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Fracture',
              value: item.effects.fracture ? 'Yes' : 'No',
              hideChevron: true
            },
            {key: 'Compare'}
          ]
        }
      ];
      break;
    case 'drug':
      medicalData = [
        {
          title: 'Properties',
          rows: [
            {key: 'Type', value: 'Painkiller', hideChevron: true},
            {key: '# of Uses', value: item.resources, hideChevron: true},
            {key: 'Use Time', value: item.useTime, hideChevron: true},
            {
              key: 'Effect Duration',
              value: item.effects.pain.duration,
              hideChevron: true
            },
            {
              key: 'Removes Pain',
              value: item.effects.pain ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Blood Loss',
              value: item.effects.bloodloss ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Contusion',
              value: item.effects.contusion ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Fracture',
              value: item.effects.bloodloss ? 'Yes' : 'No',
              hideChevron: true
            },
            {key: 'Compare'}
          ]
        }
      ];
      break;
    case 'accessory':
      medicalData = [
        {
          title: 'Properties',
          rows: [
            {key: 'Type', value: 'Painkiller', hideChevron: true},
            {key: '# of Uses', value: item.resources, hideChevron: true},
            {key: 'Use Time', value: item.useTime, hideChevron: true},
            {
              key: 'Removes Pain',
              value: item.effects.pain ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Blood Loss',
              value: item.effects.bloodloss ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Contusion',
              value: item.effects.contusion ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Fracture',
              value: item.effects.bloodloss ? 'Yes' : 'No',
              hideChevron: true
            },
            {key: 'Compare'}
          ]
        }
      ];
      break;
    case 'stimulator':
      medicalData = [
        {
          title: 'Properties',
          rows: [
            {key: 'Type', value: item.type, hideChevron: true},
            {key: '# of Uses', value: '1', hideChevron: true},
            {key: 'Use Time', value: item.useTime, hideChevron: true},
            {
              key: 'Effect Duration',
              value: item.effects.pain.duration,
              hideChevron: true
            },
            {
              key: 'Removes Pain',
              value: item.effects.pain ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Blood Loss',
              value: item.effects.bloodloss ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Contusion',
              value: item.effects.contusion ? 'Yes' : 'No',
              hideChevron: true
            },
            {
              key: 'Removes Fracture',
              value: item.effects.bloodloss ? 'Yes' : 'No',
              hideChevron: true
            },
            {key: 'Compare'}
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
