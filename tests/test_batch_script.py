import re
import unittest

class TestBatchScript(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        with open('cheatdetector.bat') as f:
            cls.content = f.read()

    def test_search_terms_list(self):
        m = re.search(r'set\s+searchTerms=\(([^)]*)\)', self.content, re.MULTILINE)
        self.assertIsNotNone(m, 'searchTerms variable not found')
        terms = re.findall(r'"([^"]+)"', m.group(1))
        expected = [
            "headshot", "primal", "unleashed", "proofcore",
            "ring-1", "arkinjector", "extreme injector",
            "HSLoaderUpdater.exe", "UWPHelper.exe", "addicted",
            "HSLoader.exe", "HSUWPHelper.exe",
            "RDPCheck.exe", "rdp", "wallhax", "Client_32.exe"
        ]
        self.assertEqual(terms, expected)

    def test_logfile_is_quoted(self):
        m = re.search(r'set\s+"?logFile=(.*)"?', self.content)
        self.assertIsNotNone(m)
        self.assertTrue(m.group(0).startswith('set "logFile='))
        # ensure all redirections use quoted logFile
        self.assertNotRegex(self.content, r'>> %logFile%')
        self.assertNotRegex(self.content, r'> %logFile%')

if __name__ == '__main__':
    unittest.main()
