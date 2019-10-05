// import {useState, useEffect} from 'react';
// import firestore from '@react-native-firebase/firestore';

// const useMetaData = () => {
//   const [state, setState] = useState({
//     loading: true,
//     error: null,
//     data: null
//   });

//   const getMetaData = async () => {
//     const metaData = await firestore()
//       .collection('global')
//       .doc('metadata')
//       .get();
//     console.log(metaData.data());
//   };

//   useEffect(() => {
//     getMetaData();
//   }, []);

//   return state;
// };

// export default useMetaData;
