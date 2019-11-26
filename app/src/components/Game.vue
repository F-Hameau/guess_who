<template>
  <div v-if="session">
    <h1>Où est {{ session.candidate }} ?</h1>

    <div>
      <img
        v-for="photo in session.photos"
        :key="photo"
        :src="'https://res.cloudinary.com/pretto-fr' + photo"
        v-on:click="pick(photo)"
      />
    </div>
  </div>
</template>

<script>
export default {
  props: ["player"],

  data: function() {
    return {
      loading: true,
      session: {
        score: 0,
        candidate: "Raphael",
        photos: [
          "/image/upload/v1573665459/team/raphael.jpg",
          "/image/upload/v1573665459/team/matthieu-taverna.jpg",
          "/image/upload/v1573665459/team/Agathe.jpg",
          "/image/upload/v1573665459/team/Marine.jpg",
          "/image/upload/v1573665459/team/Benjamin.jpg",
          "/image/upload/v1573665459/team/Helene.jpg"
        ],
        over: false
      }
    };
  },

  methods: {
    pick(photo) {
      alert(photo);
    }
  },

  async created() {
    const res = await fetch("http://localhost:4567/" + this.player);
    const session = await res.json();
    this.session = session;
  }
};
</script>

<style scoped>
template {
  text-align: center;
}
img {
  height: 200px;
  width: 200px;
  margin: 20px;
}
</style>