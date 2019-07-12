import unittest
import pulumi
import ecr

pulumi.runtime.settings._set_test_mode_enabled(True)    # This should be able to be set via PULUMI_TEST_MODE
pulumi.runtime.settings._set_project('hello-fargate')
pulumi.runtime.settings._set_stack('dev')

class TestEcr(unittest.TestCase):
    """test class of ecr.py
    """

    def test_ecr(self):
        """test method for ecr
        """
        # pulumi.apply()
        for x in dir(ecr.pulumi):
            print(x)
        stack = pulumi.get_stack()
        print(stack)
        ecr.create_repository("hoge")
        self.assertEqual(1, 1)


if __name__ == "__main__":
    unittest.main()