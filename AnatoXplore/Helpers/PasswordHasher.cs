using System;
using System.Security.Cryptography;
using System.Text;

namespace AnatoXplore
{
    // Turns a password into a SHA-256 hash, so the real password is never stored.
    public static class PasswordHasher
    {
        public static string Hash(string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.Unicode.GetBytes(password));
                return BitConverter.ToString(bytes).Replace("-", "");
            }
        }
    }
}