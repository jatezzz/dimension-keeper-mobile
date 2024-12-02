import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_and_morty_app/models/character.dart';
import 'package:rick_and_morty_app/models/status_extension.dart';
import 'package:rick_and_morty_app/providers/character_provider.dart';
import 'package:rick_and_morty_app/repositories/character_repository.dart';

// Generate Mocks.
@GenerateMocks([CharacterRepository])
import 'character_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCharacterRepository mockRepository;
  late CharacterProvider provider;

  setUp(() {
    mockRepository = MockCharacterRepository();
    provider = CharacterProvider(mockRepository);
  });

  group('CharacterProvider Tests', () {
    test('should fetch my characters successfully', () async {
      // Arrange
      final mockCharacters = [
        Character(
          id: '1',
          name: 'Rick Sanchez',
          image: 'rick.png',
          status: Status.alive,
          species: 'Human',
          gender: 'Male',
        ),
      ];
      when(mockRepository.fetchMyCharacters()).thenAnswer((_) async => mockCharacters);

      // Act
      await provider.fetchMyCharacters();

      // Assert
      expect(provider.myCharacters, equals(mockCharacters));
      verify(mockRepository.fetchMyCharacters()).called(1);
    });

    test('should fetch all characters successfully', () async {
      // Arrange
      final mockCharacters = [
        Character(
          id: '1',
          name: 'Morty Smith',
          image: 'morty.png',
          status: Status.alive,
          species: 'Human',
          gender: 'Male',
        ),
      ];
      when(mockRepository.fetchAllCharacters(any)).thenAnswer((_) async => mockCharacters);

      // Act
      when(mockRepository.fetchAllCharacters(1)).thenAnswer((_) async => []);
      await provider.fetchAllCharacters();

      // Act
      provider.resetCharacters();

      // Assert
      expect(provider.allCharacters.isEmpty, true);
      expect(provider.isLoading, false);
    });

    test('should fetch all characters by name successfully', () async {
      // Arrange
      final mockCharacters = [
        Character(
          id: '1',
          name: 'Summer Smith',
          image: 'summer.png',
          status: Status.alive,
          species: 'Human',
          gender: 'Female',
        ),
      ];
      when(mockRepository.fetchAllCharactersByName('Summer')).thenAnswer((_) async => mockCharacters);

      // Act
      await provider.fetchAllCharactersByName('Summer');

      // Assert
      expect(provider.allCharacters, equals(mockCharacters));
      verify(mockRepository.fetchAllCharactersByName('Summer')).called(1);
    });

    test('should create character successfully', () async {
      // Arrange
      final newCharacter = Character(
        id: '2',
        name: 'Beth Smith',
        image: 'beth.png',
        status: Status.alive,
        species: 'Human',
        gender: 'Female',
      );
      when(mockRepository.createCharacter(newCharacter)).thenAnswer((_) async => Future.value());

      // Act
      await provider.createCharacter(newCharacter, null);

      // Assert
      expect(provider.myCharacters.contains(newCharacter), true);
      verify(mockRepository.createCharacter(newCharacter)).called(1);
    });

    test('should delete character successfully', () async {
      // Arrange
      final characterToDelete = Character(
        id: '1',
        name: 'Rick Sanchez',
        image: 'rick.png',
        status: Status.alive,
        species: 'Human',
        gender: 'Male',
      );
      provider.myCharacters.add(characterToDelete);
      when(mockRepository.deleteCharacter(characterToDelete.id)).thenAnswer((_) async => Future.value());

      // Act
      await provider.deleteCharacter(characterToDelete.id, null);

      // Assert
      expect(provider.myCharacters.contains(characterToDelete), false);
      verify(mockRepository.deleteCharacter(characterToDelete.id)).called(1);
    });
  });

  test('should fetch all characters successfully', () async {
    // Arrange
    final mockCharacters = [
      Character(
        id: '1',
        name: 'Morty Smith',
        image: 'morty.png',
        status: Status.alive,
        species: 'Human',
        gender: 'Male',
      ),
    ];
    when(mockRepository.fetchAllCharacters(any)).thenAnswer((_) async => mockCharacters);

    // Act
    await provider.fetchAllCharacters();

    // Assert
    expect(provider.allCharacters, equals(mockCharacters));
    verify(mockRepository.fetchAllCharacters(1)).called(1);
  });

  test('should clear characters list', () {
    // Arrange
    provider.fetchAllCharacters();

    // Act
    provider.clearCharacters();

    // Assert
    expect(provider.allCharacters.isEmpty, true);
    expect(provider.isLoading, true);
  });

  test('should reset characters list', () {
    // Arrange
    provider.fetchAllCharacters();

    // Act
    provider.resetCharacters();

    // Assert
    expect(provider.allCharacters.isEmpty, true);
    expect(provider.isLoading, false);
  });

  test('should fetch all characters by name successfully', () async {
    // Arrange
    final mockCharacters = [
      Character(
        id: '1',
        name: 'Summer Smith',
        image: 'summer.png',
        status: Status.alive,
        species: 'Human',
        gender: 'Female',
      ),
    ];
    when(mockRepository.fetchAllCharactersByName('Summer')).thenAnswer((_) async => mockCharacters);

    // Act
    await provider.fetchAllCharactersByName('Summer');

    // Assert
    expect(provider.allCharacters, equals(mockCharacters));
    verify(mockRepository.fetchAllCharactersByName('Summer')).called(1);
  });

  test('should create character successfully', () async {
    // Arrange
    final newCharacter = Character(
      id: '2',
      name: 'Beth Smith',
      image: 'beth.png',
      status: Status.alive,
      species: 'Human',
      gender: 'Female',
    );
    when(mockRepository.createCharacter(newCharacter)).thenAnswer((_) async => Future.value());

    // Act
    await provider.createCharacter(newCharacter, null);

    // Assert
    expect(provider.myCharacters.contains(newCharacter), true);
    verify(mockRepository.createCharacter(newCharacter)).called(1);
  });

  test('should update character successfully', () async {
    // Arrange
    final existingCharacter = Character(
      id: '1',
      name: 'Rick Sanchez',
      image: 'rick.png',
      status: Status.alive,
      species: 'Human',
      gender: 'Male',
    );
    final updatedCharacter = Character(
      id: '1',
      name: 'Rick Sanchez Updated',
      image: 'rick.png',
      status: Status.alive,
      species: 'Human',
      gender: 'Male',
    );
    provider.myCharacters.add(existingCharacter);
    when(mockRepository.updateCharacter(updatedCharacter)).thenAnswer((_) async => Future.value());

    // Act
    await provider.updateCharacter(updatedCharacter, null);

    // Assert
    expect(provider.myCharacters.first.name, equals('Rick Sanchez Updated'));
    verify(mockRepository.updateCharacter(updatedCharacter)).called(1);
  });

  test('should delete character successfully', () async {
    // Arrange
    final characterToDelete = Character(
      id: '1',
      name: 'Rick Sanchez',
      image: 'rick.png',
      status: Status.alive,
      species: 'Human',
      gender: 'Male',
    );
    provider.myCharacters.add(characterToDelete);
    when(mockRepository.deleteCharacter(characterToDelete.id)).thenAnswer((_) async => Future.value());

    // Act
    await provider.deleteCharacter(characterToDelete.id, null);

    // Assert
    expect(provider.myCharacters.contains(characterToDelete), false);
    verify(mockRepository.deleteCharacter(characterToDelete.id)).called(1);
  });
}
