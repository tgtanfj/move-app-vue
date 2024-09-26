import { defineStore } from 'pinia'
import { signInWithPopup, GoogleAuthProvider } from "firebase/auth";
import { auth } from '../services/firebaseConfig.js'
import { ref } from 'vue';

export const useAuthStore = defineStore('auth', () => {
    // States
    const user = ref({})
    const loading = ref(false);
    const error = ref(null);

    // Actions
    const googleSignIn = async () => {
        const provider = new GoogleAuthProvider()
        try {
            const result = await signInWithPopup(auth, provider);
            user.value = result.user;
            console.log("User info:", user.value);
        } catch (err) {
            error.value = err.message;
            console.error("Error during Google login:", error.value);
        } finally {
            loading.value = false;
        }
    }

    return {
        // states
        user, loading, error,
        // actions
        googleSignIn
    }
})