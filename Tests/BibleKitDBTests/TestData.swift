@testable import BibleKitDB
import Foundation

enum TestData {
    static let genesisVerses = [
        VerseEntity(
            id: "1:1:1",
            text: "In the beginning GOD created the heavens and the earth."
        ),
        VerseEntity(
            id: "1:1:2",
            text: "And the earth was a formless and desolate emptiness, and darkness was over the surface of the deep, and the Spirit of GOD was hovering over the surface of the waters."
        ),
        VerseEntity(
            id: "1:1:3",
            text: "Then GOD said, \"Let there be light\"; and there was light."
        ),
        VerseEntity(
            id: "1:1:4",
            text: "GOD saw that the light was good; and GOD separated the light from the darkness."
        ),
        VerseEntity(
            id: "1:1:5",
            text: "GOD called the light day, and the darkness He called night. And there was evening and there was morning, one day."
        ),
        VerseEntity(
            id: "1:1:6",
            text: "Then GOD said, \"Let there be an expanse in the midst of the waters, and let it separate the waters from the waters.\""
        ),
    ]

    static let psalmVerses = [
        VerseEntity(
            id: "19:23:1",
            text: "The LORD is my shepherd, I shall not want."
        ),
        VerseEntity(
            id: "19:23:2",
            text: "He makes me lie down in green pastures; He leads me beside quiet waters."
        ),
        VerseEntity(
            id: "19:23:3",
            text: "He restores my soul; He guides me in the paths of righteousness For His name's sake."
        ),
        VerseEntity(
            id: "19:23:4",
            text: "Even though I walk through the valley of the shadow of death, I fear no evil, for You are with me; Your rod and Your staff, they comfort me."
        ),
        VerseEntity(
            id: "19:23:5",
            text: "You prepare a table before me in the presence of my enemies; You have anointed my head with oil; My cup overflows."
        ),
        VerseEntity(
            id: "19:23:6",
            text: "Surely goodness and lovingkindness will follow me all the days of my life, And I will dwell in the house of the LORD forever."
        ),
    ]

    static let johnVerses = [
        VerseEntity(
            id: "43:3:16",
            text: "For God so loved the world, that He gave His only begotten Son, that whoever believes in Him shall not perish, but have eternal life."
        ),
        VerseEntity(
            id: "43:3:17",
            text: "For God did not send the Son into the world to judge the world, but that the world might be saved through Him."
        ),
        VerseEntity(
            id: "43:3:18",
            text: "He who believes in Him is not judged; he who does not believe has been judged already, because he has not believed in the name of the only begotten Son of God."
        ),
        VerseEntity(
            id: "43:3:19",
            text: "This is the judgment, that the Light has come into the world, and men loved the darkness rather than the Light, for their deeds were evil."
        ),
        VerseEntity(
            id: "43:3:20",
            text: "For everyone who does evil hates the Light, and does not come to the Light for fear that his deeds will be exposed."
        ),
        VerseEntity(
            id: "43:3:21",
            text: "But he who practices the truth comes to the Light, so that his deeds may be manifested as having been wrought in God."
        ),
    ]

    static let allVerses = genesisVerses + psalmVerses + johnVerses
}
