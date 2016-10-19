<template>
  <div>
  <h1>Matches</h1>
  <ul v-if="matches">
      <li v-for="match in matches">
        <p>
          {{ match.id }}
        </p>
        <p>
          {{ match.style }}
        </p>
        <p>
          {{ match.game }}
        </p>
        <p>
          {{ match.home_team }}
        </p>
        <p>
          {{ match.invited_team }}
        </p>
      </li>
    </ul>
    <p v-else>
      No matches yet
    </p>
  </div>
</template>

<script>
  import { getMatches } from 'src/api'

  export default {
    data () {
      return {
        matches: []
      }
    },
    mounted () {
      getMatches().then(response => {
        this.matches = response.data
      })
    },
    methods: {}
  }
</script>

<style>
</style>
