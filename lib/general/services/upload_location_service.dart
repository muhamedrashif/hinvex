import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UploadPlaceService {
  UploadPlaceService(this.firebaseFirestore);
  final FirebaseFirestore firebaseFirestore;

  FutureResult<Unit> uploadPlace(PlaceCell placeCell) async {
    // ignore: cascade_invocations
    try {
      // add Local area
      final district = await firebaseFirestore
          .collection('locations')
          .doc(placeCell.country)
          .collection(placeCell.state)
          .doc(placeCell.state)
          .collection(placeCell.district)
          .doc(placeCell.district)
          .get();
      if (district.exists) {
        final localAreaList =
            (district.data()?['localArea'] as List<dynamic>?) ?? [];

        if (!localAreaList.contains(placeCell.localArea)) {
          await firebaseFirestore
              .collection('locations')
              .doc(placeCell.country)
              .collection(placeCell.state)
              .doc(placeCell.state)
              .collection(placeCell.district)
              .doc(placeCell.district)
              .update({
            'localArea': FieldValue.arrayUnion([
              placeCell.localArea,
            ]),
          });
        }
        return right(unit); // stop and set location
      }

      // add district
      final state = await firebaseFirestore
          .collection('locations')
          .doc(placeCell.country)
          .collection(placeCell.state)
          .doc(placeCell.state)
          .get();

      if (state.exists) {
        final districtList =
            (state.data()?['district'] as List<dynamic>?) ?? [];

        final batch = firebaseFirestore.batch();
        if (!districtList.contains(placeCell.district)) {
          batch.update(
            firebaseFirestore
                .collection('locations')
                .doc(placeCell.country)
                .collection(placeCell.state)
                .doc(placeCell.state),
            {
              'district': FieldValue.arrayUnion([placeCell.district]),
            },
          );
        }
        batch.set(
          firebaseFirestore
              .collection('locations')
              .doc(placeCell.country)
              .collection(placeCell.state)
              .doc(placeCell.state)
              .collection(placeCell.district)
              .doc(placeCell.district),
          {
            'localArea': FieldValue.arrayUnion([placeCell.localArea]),
          },
        );

        await batch.commit();
        return right(unit); // stop and set location
      }

      // add state
      final country = await firebaseFirestore
          .collection('locations')
          .doc(placeCell.country)
          .get();
      if (country.exists) {
        final stateList = (country.data()?['state'] as List<dynamic>?) ?? [];

        final batch = firebaseFirestore.batch();
        if (!stateList.contains(placeCell.state)) {
          batch.update(
            // update
            firebaseFirestore.collection('locations').doc(placeCell.country),
            {
              'state': FieldValue.arrayUnion([placeCell.state]),
            },
          );
        }
        batch
          ..set(
            firebaseFirestore
                .collection('locations')
                .doc(placeCell.country)
                .collection(placeCell.state)
                .doc(placeCell.state),
            {
              'district': FieldValue.arrayUnion([placeCell.district]),
            },
          )
          ..set(
            firebaseFirestore
                .collection('locations')
                .doc(placeCell.country)
                .collection(placeCell.state)
                .doc(placeCell.state)
                .collection(placeCell.district)
                .doc(placeCell.district),
            {
              'localArea': FieldValue.arrayUnion([placeCell.localArea]),
            },
          );

        await batch.commit();
        return right(unit); // stop and set location
      }

      // add country
      final batch = firebaseFirestore.batch()
        ..set(
          // set
          firebaseFirestore.collection('locations').doc(placeCell.country),
          {
            'state': FieldValue.arrayUnion([placeCell.state]),
          },
        )
        ..set(
          firebaseFirestore
              .collection('locations')
              .doc(placeCell.country)
              .collection(placeCell.state)
              .doc(placeCell.state),
          {
            'district': FieldValue.arrayUnion([placeCell.district]),
          },
        )
        ..set(
          firebaseFirestore
              .collection('locations')
              .doc(placeCell.country)
              .collection(placeCell.state)
              .doc(placeCell.state)
              .collection(placeCell.district)
              .doc(placeCell.district),
          {
            'localArea': FieldValue.arrayUnion([placeCell.localArea]),
          },
        );

      await batch.commit();
      return right(unit); // stop and set location
    } on FirebaseException catch (e) {
      return left(
        MainFailure.serverFailure(
          errorMsg: e.code,
        ),
      );
    } catch (e) {
      return left(
        MainFailure.serverFailure(
          errorMsg: '$e',
        ),
      );
    }
  }
}
